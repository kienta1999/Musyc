//
//  SearchViewController.swift
//  MUSYC
//
//  Created by Kien Ta on 11/26/20.
//  Copyright © 2020 Anh Le. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
        struct Token: Decodable {
          let access_token: String
        }
        
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
    
        struct APIResultsWrapper: Decodable{
            let tracks: APIResults
        }
        struct APIResults:Decodable {
            let href: String
            let items: [Track]
            let limit: Int
            let next: String?
            let offset: Int
            let previous: String?
            let total: Int
        }
        
        struct Track: Decodable {
            let name: String
            let album: Album
            let preview_url: String!
            let artists: [Artist]
        }
        struct Album: Decodable{
            let images: [AlbumImage]
        }
        struct AlbumImage: Decodable{
            let url: String
        }
    
        struct Artist: Decodable{
            let name: String
        }
        
        

        //let client_id = "4c4b5879f3d74b2fac7b995cca064abd";
        //let client_secret = "027be414fc074154aa5bbe847fe2f354"

        
        @IBOutlet weak var trackQuery: UISearchBar!
    
        @IBOutlet weak var trackTableView: UITableView!
    
        override func viewDidLoad() {
            super.viewDidLoad()
            self.title = "Search"
            // Do any additional setup after loading the view.
//            if(UserDefaults.standard.string(forKey: "access_token") == nil){
//                
//            }
            UserDefaults.standard.set(SearchViewController.getAccessToken(), forKey: "access_token")
            //print(access_token)
            setupTableView()
            trackQuery.delegate = self
        }
        
        
        static func getAccessToken() -> String{
            let refresh_token = "AQBcAsJod-8i1B13F9DI1ylAMfcpQykIyXnzjvfdXStdzeANmgYc3e_DbqxI4GqOIQEarRx4ShPKngC3KWtyv_f3NO2macj_J7ph_g0A4wLQ-DOL3ke5t5W4xbvOTmKrhYE";
            let encoded_64_id_secret = "NGM0YjU4NzlmM2Q3NGIyZmFjN2I5OTVjY2EwNjRhYmQ6MDI3YmU0MTRmYzA3NDE1NGFhNWJiZTg0N2ZlMmYzNTQ=";
            var ans = "error"
            let url = URL(string: "https://accounts.spotify.com/api/token")!
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!

            components.queryItems = [
                URLQueryItem(name: "grant_type", value: "refresh_token"),
                URLQueryItem(name: "refresh_token", value: refresh_token)
    //            ,URLQueryItem(name: "client_id", value: client_id)
    //            ,URLQueryItem(name: "client_secret", value: client_secret)
            ]

            let query = components.url!.query
            
            var request = URLRequest(url: url)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("Basic " + encoded_64_id_secret, forHTTPHeaderField: "Authorization")
            request.httpMethod = "POST"
            request.httpBody = Data(query!.utf8)
            
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
                    return
                }

                let responseString = String(data: data, encoding: .utf8)
                //self.access_token = responseString!.components(separatedBy: "\"")[3]
                ans = responseString!.components(separatedBy: "\"")[3]
            }
            task.resume()
            sleep(1)
            return ans
        }
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return theData.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let myCell = tableView.dequeueReusableCell(withIdentifier: "theCell")! as UITableViewCell
            myCell.textLabel!.text = theData[indexPath.row]
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
            let url = URL(string: "https://api.spotify.com/v1/search")!
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!

            components.queryItems = [
                URLQueryItem(name: "q", value: self.trackQuery.text!),
                URLQueryItem(name: "type", value: "track")
            ]
            print(components.url!)
            var request = URLRequest(url: components.url!)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer " + UserDefaults.standard.string(forKey: "access_token")!, forHTTPHeaderField: "Authorization")
            request.httpMethod = "GET"
    //        request.httpBody = Data(query!.utf8)

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
                print(responseString)
                
                
                do{
                    let tempData = (try JSONDecoder().decode(APIResultsWrapper.self, from: Data(responseString.utf8))).tracks.items
                    var tempTrack:[String] = []
                    for element in tempData{
                        tempTrack.append(element.name)
                        self.theImage.append(element.album.images[0].url)
                        self.thePreviewUrl.append(element.preview_url ?? nil)
                        self.theArtist.append(element.artists[0].name)
                    }
                    self.theData = tempTrack
                }
                catch{
                    print("Not valid json")
                }
            }
            
            task.resume()
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let detailedVC = TrackDetailedViewController()
            let index = indexPath.row
            detailedVC.trackTitle = theData[index]
            detailedVC.urlImg = theImage[index]
            detailedVC.urlPreview = thePreviewUrl[index]
            detailedVC.artist = theArtist[index]
            self.navigationController?.pushViewController(detailedVC, animated: true)
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            fetchTracksForTableiew()
        }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
