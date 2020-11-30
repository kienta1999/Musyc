//
//  AlbumViewController.swift
//  MUSYC
//
//  Created by Kien Ta on 11/30/20.
//  Copyright © 2020 Anh Le. All rights reserved.
//

import UIKit

class AlbumViewController: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    struct APIResultsWrapper: Decodable{
            let albums: APIResults
        }
        struct APIResults:Decodable {
            let href: String
            let items: [Album]
            let limit: Int
            let next: String?
            let offset: Int
            let previous: String?
            let total: Int
        }
        
        struct Album: Decodable {
            let name: String
            let images: [AlbumImage]
            let artists: [Artist]
        }
        struct AlbumImage: Decodable{
            let url: String
        }
    
        struct Artist: Decodable{
            let name: String
        }
    
    var theData: [String] = []
    var theImage: [String] = []
    var theArtist: [String] = []
    var images: [UIImage] = []
    let numRow = 2
    var numCol = 10
    
    @IBOutlet weak var albumQuery: UISearchBar!
    
    @IBOutlet weak var albumCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        albumQuery.delegate = self
        self.title = "Album"
        setupCollectionView()
        setUpCellSize()
//        if(UserDefaults.standard.string(forKey: "access_token") == nil){
//
//        }
        UserDefaults.standard.set(SearchViewController.getAccessToken(), forKey: "access_token")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numRow;
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numCol;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath)
        let index = indexPath.section * numRow + indexPath.row
        if(theData.count == 0){
            let spinner = UIActivityIndicatorView(style: .large)
            spinner.hidesWhenStopped = true
            cell.backgroundView = spinner
            spinner.startAnimating()
        }
        else if(theData.count > index){
            let title = theData[index]
            let image = images[index]
    //            print(title + " " + image.description)
            let wrapperFrame = CGRect(x: collectionView.frame.minX, y: collectionView.frame.minY, width: collectionView.frame.width, height: collectionView.frame.height)
            let wrapperView = UIView(frame: wrapperFrame)
            cell.backgroundView = wrapperView
            
            let imageFrame = CGRect(x: wrapperView.frame.minX, y: wrapperView.frame.minY, width: wrapperView.frame.width, height: wrapperView.frame.height)
            let imageView: UIImageView = UIImageView(image: image)
            imageView.frame = imageFrame
            wrapperView.addSubview(imageView)
            
           let titleHeight = CGFloat(40)
            let titleFrame = CGRect(x: imageFrame.minX, y: imageFrame.maxY - titleHeight, width: imageFrame.width, height: titleHeight)
            let movieTitle = UITextView(frame: titleFrame)
            movieTitle.text = title
            movieTitle.textColor = .white
            movieTitle.textAlignment = .center
            movieTitle.backgroundColor = .gray
            imageView.addSubview(movieTitle)
        }
        else{
            cell.backgroundView = nil
        }
        return cell
    }
    
    func setupCollectionView(){
        albumCollectionView.dataSource = self
        albumCollectionView.delegate = self
        albumCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "myCell")
    }
    
    func fetchAlbumForCollectionView() {
            theImage = []
            theArtist = []
            images = []
            let url = URL(string: "https://api.spotify.com/v1/search")!
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!

            components.queryItems = [
                URLQueryItem(name: "q", value: self.albumQuery.text!),
                URLQueryItem(name: "type", value: "album")
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
//                        self.fetchAlbumForCollectionView()
                    }
                    return
                }
                let responseString = String(data: data, encoding: .utf8)!.replacingOccurrences(of: "\\/", with: "/")
                print(responseString)
                
                
                do{
                    let tempData = (try JSONDecoder().decode(APIResultsWrapper.self, from: Data(responseString.utf8))).albums.items
                    var tempAlbumName:[String] = []
                    for element in tempData{
                        tempAlbumName.append(element.name)
                        self.theImage.append(element.images[0].url)
                        self.theArtist.append(element.artists[0].name)
                    }
                    self.theData = tempAlbumName
                    
                    DispatchQueue.main.async {
                        for imgUrl in self.theImage{
                            self.images.append(self.getImage(imgUrl))
                        }
                        self.numCol = (self.theData.count + 1) / self.numRow
                        self.albumCollectionView.reloadData()
                    }
                }
                catch{
                    print("Not valid json")
                }
            }
            
            task.resume()
        }
    
    func setUpCellSize(){
        let cellSize = CGSize(width: view.frame.width / 2 - 5 , height:150)

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical //.horizontal
        layout.itemSize = cellSize
        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        albumCollectionView.setCollectionViewLayout(layout, animated: true)
    }
    
       func getImage(_ path: String) -> UIImage{
               let url = URL(string: path)
               let data = try? Data(contentsOf: url!)
                return UIImage(data: data!)!
        }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchAlbumForCollectionView()
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
