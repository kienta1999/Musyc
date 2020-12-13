//
//  SearchNesteaseViewController.swift
//  MUSYC
//
//  Created by Xiaoyu Liu on 12/12/20.
//  Copyright © 2020 Anh Le. All rights reserved.
//

import UIKit

class SearchNesteaseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var trackTableView: UITableView!
    @IBOutlet weak var trackQuery: UISearchBar!
    let defaultAddress = "http://ec2-13-250-43-149.ap-southeast-1.compute.amazonaws.com:3000"
    
    var theData: [String] = [] {
        didSet{
            DispatchQueue.main.async {
                self.trackTableView.reloadData()
            }
        }
    }
    var theImage: [String] = []
    var thePreviewUrl: [String?] = []
    var theArtist: [String] = []
    var theUri: [String] = []
    var theId:[Int] = []
    
    struct APIResultsWrapper: Decodable{
       let result: Songs
   }
    
    struct Songs:Decodable {
        let songs:[Song]
    }
    
    struct Song: Decodable{
        let id: Int
        let name: String
        let artists: [Artist]
        let album: Album
    }
    
    struct Artist:Decodable{
        let id:Int
        let name: String
        let img1v1Url:String
    }
    
    struct Album:Decodable{
        let artist:Artist
    }
    
    struct MusicInfo: Decodable{
        var data: [MusicFile]
        var code: Int
    }
    
    struct MusicFile: Decodable{
        var url: String
    }
    
    
    
//           struct APIResults:Decodable {
//               let href: String
//               let items: [Track]
//               let limit: Int
//               let next: String?
//               let offset: Int
//               let previous: String?
//               let total: Int
//           }
//
//           struct Track: Decodable {
//               let name: String
//               let album: Album
//               let preview_url: String!
//               let artists: [Artist]
//               let uri: String
//           }
//           struct Album: Decodable{
//               let images: [AlbumImage]
//           }
//           struct AlbumImage: Decodable{
//               let url: String
//           }
//
//           struct Artist: Decodable{
//               let name: String
//           }
    

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        trackTableView.backgroundColor =  UIColor.init(red: 87/255, green: 77/255, blue: 77/255, alpha: 1.0)
        super.viewDidLoad()
        self.title = "Search"
    // Do any additional setup after loading the view.
        setupTableView()
        trackQuery.delegate = self
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "theCell")! as UITableViewCell
                   myCell.textLabel!.text = theData[indexPath.row] + " (" + theArtist[indexPath.row] + ")"
                   myCell.backgroundColor = UIColor.init(red: 87/255, green: 77/255, blue: 77/255, alpha: 1.0)
                   myCell.textLabel!.textColor = .white
                   return myCell
    }
    
    func setupTableView(){
        trackTableView.dataSource = self
        trackTableView.delegate = self
        trackTableView.register(UITableViewCell.self, forCellReuseIdentifier: "theCell")
    }
    
    
    func fetchTracksForTableiew() {
        theImage = []
        thePreviewUrl = []
        theArtist = []
        theUri = []
        theId = []
        let keyword = "/search?"
        let url = URL(string: defaultAddress+keyword)!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!

        components.queryItems = [
            URLQueryItem(name: "keywords", value: self.trackQuery.text!),
            URLQueryItem(name: "limit", value: "30")//default is 30
        ]
        print(components.url!)
        var request = URLRequest(url: components.url!)
//                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//                request.setValue("Bearer " + UserDefaults.standard.string(forKey: "access_token")!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        //        request.httpBody = Data(query!.utf8)
//
        let task = URLSession.shared.dataTask(with: request) { data, response, error in

            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {                                              // check for fundamental networking error
                print("error", error ?? "Unknown error")
                return
            }

            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                //the access token is expired - need to get a new one
                if(response.statusCode == 401){
                    UserDefaults.standard.set(SearchViewController.getAccessToken(), forKey: "access_token")
//                        self.fetchTracksForTableiew()
                }
                return
            }
            let responseString = String(data: data, encoding: .utf8)!.replacingOccurrences(of: "\\/", with: "/")
//            print("responseString"+responseString)


            do{
//                print("try decode")
                let songs = (try JSONDecoder().decode(APIResultsWrapper.self, from: Data(responseString.utf8))).result.songs
//                print("songs", songs.count)
                var tempTrack:[String] = []
                for element in songs{
                    tempTrack.append(element.name)
                    self.theImage.append(element.album.artist.img1v1Url)
                    self.thePreviewUrl.append(element.album.artist.img1v1Url)
                    self.theArtist.append(element.artists[0].name)
                    self.theUri.append(self.IdToUrl(id: element.id))
                    self.theId.append(element.id)

                }

//                print("theImage.capacity: ", self.theImage.count)
//                print("thePreviewUrl", self.thePreviewUrl.count)
//                print("theArtist", self.theArtist.count)
//                print("the url", self.theUri.count)
//                print("the id", self.theId.count)
                self.theData = tempTrack
            }
            catch{
                print("Not valid json")
            }
        }

        task.resume()
            }
            
    func IdToUrl(id:Int) -> String {
         let url = defaultAddress + "/song/url?id=" + String(id) + "&br=999000"
//        print(url)
        return url
    }
    
    static func urlToMusicUrl(url:String) -> String {
        print("url: \(url)")
        let data = try! Data(contentsOf: URL(string:url)!)
        let theMusic = try! JSONDecoder().decode(MusicInfo.self, from: data)
        
        if (theMusic.code >= 200 && theMusic.code < 300) {
            print("find musicUrl")
            let musicUrl = theMusic.data[0].url
            if (musicUrl.isEmpty || musicUrl.count == 0) {
                print("url is empty")
                return ""
            }
            return theMusic.data[0].url
        } else {
            print("fail to get music, code is \(theMusic.code)")
            return ""
        }
    }
    
    
            func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                let detailedVC = TrackDetailedViewController()
                let index = indexPath.row
                detailedVC.trackTitle = theData[index]
                detailedVC.urlImg = theImage[index]
                detailedVC.urlPreview = thePreviewUrl[index]
                detailedVC.artist = theArtist[index]
                detailedVC.uri = theUri[index]
                detailedVC.downloadable = true
                
                self.navigationController?.pushViewController(detailedVC, animated: true)
            }
            
            func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
                fetchTracksForTableiew()
            }
    
}
