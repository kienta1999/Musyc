//
//  TrackDetailedViewController.swift
//  MUSYC
//
//  Created by Kien Ta on 11/30/20.
//  Copyright © 2020 Anh Le. All rights reserved.
//

import UIKit
import AVFoundation

class TrackDetailedViewController: UIViewController {
    
    var trackTitle: String!
    var urlImg: String!
    var urlPreview: String!
    var artist: String!
    var player: AVPlayer!
    var uri: String!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = trackTitle
        
        view.backgroundColor = UIColor.init(red: 87/255, green: 77/255, blue: 77/255, alpha: 1.0)
        
        let imageRatio = CGFloat(3)
        let image = getImage(urlImg)
        let theImageFrame = CGRect(x: view.frame.midX - image.size.width / imageRatio / 2 , y: 90, width: image.size.width / imageRatio, height: image.size.height / imageRatio)
        let imageView = UIImageView(frame: theImageFrame)
        imageView.image = image
        
        view.addSubview(imageView)
        
        let distanceBtwElement = CGFloat(30)
        
        let theNameFrame = CGRect(x: 0, y: image.size.height / imageRatio + 110, width: view.frame.width, height: 30)
        let nameView = UILabel(frame: theNameFrame)
        nameView.text = trackTitle
        nameView.textAlignment = .center
        nameView.textColor = .white
        view.addSubview(nameView)
        
        let theArtistFrame = CGRect(x: 0, y: image.size.height / imageRatio + 110 + distanceBtwElement, width: view.frame.width, height: 30)
        let artistView = UILabel(frame: theArtistFrame)
        artistView.text = artist
        artistView.textAlignment = .center
        artistView.textColor = .white
        view.addSubview(artistView)
        
        let streamBtnFrame = CGRect(x: 0, y: image.size.height / imageRatio + 110 + distanceBtwElement * 2, width: view.frame.width, height: 30)
        let streamBtn = UIButton(frame: streamBtnFrame)
        streamBtn.backgroundColor = UIColor(named: "buttonBackground")
        streamBtn.setTitle("Stream", for: .normal)
        streamBtn.setTitleColor(.systemTeal, for: .normal)
        streamBtn.setTitleColor(.green, for: .normal)
        streamBtn.layer.borderColor = UIColor(named: "buttonBorder")?.cgColor
        streamBtn.addTarget(self, action: #selector(streamBtnClicked), for: .touchUpInside)
        view.addSubview(streamBtn)
        
        let heightLyricFrame = image.size.height / imageRatio + 110 + distanceBtwElement * 3
        let lyricFrame = CGRect(x: 0, y: heightLyricFrame, width: view.frame.width, height: view.frame.height - heightLyricFrame)
        let lyricView = UITextView(frame: lyricFrame)
        lyricView.text = getLyric(trackTitle, artist)
        lyricView.textColor = .white
        lyricView.font = UIFont.boldSystemFont(ofSize: 16)
        lyricView.backgroundColor = .clear
        lyricView.isEditable = false
        lyricView.isScrollEnabled = true
        view.addSubview(lyricView)
        
//        print(getLyric(trackTitle, artist))
        //play(urlPreview)
    }
    
        @objc func streamBtnClicked(){
            print(TrackDetailedViewController.uriToUrl(uri))
            let webVC = WebViewController()
            let searchURL = TrackDetailedViewController.uriToUrl(uri)
            let url = URL(string: searchURL)!
            let spotifyURLRequest = URLRequest(url: url)
            
            webVC.url = spotifyURLRequest
            webVC.name = trackTitle
            
            navigationController?.pushViewController(webVC, animated: true)
        }
    
    static func uriToUrl(_ uri: String!) -> String{
        if uri != nil {
            return "https://open.spotify.com" + uri.suffix(uri.count - 7).replacingOccurrences(of: ":", with: "/")
        }
        else {
            return "https://open.spotify.com/track/0cCm1PbOd6nqAPDdA3PRfs"
        }
            
    }
    
    func getImage(_ path: String) -> UIImage{
           let url = URL(string: path)
           let data = try? Data(contentsOf: url!)
//           if(data == nil){
//               return UIImage(named: "img_not_found")!
//           }
        return UIImage(data: data!)!
    }
    
    struct APIResultsSearch: Decodable {
        let result: [TrackInfo]
    }
    struct TrackInfo:Decodable {
        let haslyrics: Bool
        let api_lyrics: String
    }
    
    struct APIResultsLyric: Decodable {
        let result: lyricsInfor
    }
    struct lyricsInfor:Decodable {
        let lyrics: String
    }
    
    func getLyric(_ track: String, _ artist: String) -> String {
        let apiKeyHappi = "f5354cE0MKiNRwRBV1sE5SlRL0FvzkSA0VtdcqO5pG9UfTw825eulg4h"
        let scheme = "https"
        let host = "api.happi.dev"
        let path = "/v1/music"
        let queryItem1 = URLQueryItem(name: "apikey", value: apiKeyHappi)
        let queryItem2 = URLQueryItem(name: "q", value: track + " " + artist)
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = [queryItem1, queryItem2]
        
        var api_lyrics: String?
        if let url = urlComponents.url{
            print(url)
            do{
                let data = try Data(contentsOf: url)
                let tempData = try JSONDecoder().decode(APIResultsSearch.self, from:data)
                if(tempData.result.count > 0 && tempData.result[0].haslyrics){
                    api_lyrics = tempData.result[0].api_lyrics
                }
//                totalPageNum = tempData.total_pages
//                theData = tempData.results
            }
            catch{
                print("Data not found")
            }
        }
        var lyrics_found = ""
        if let api_lyrics_unwrap = api_lyrics {
            let url_lyrics = api_lyrics_unwrap + "?apikey=" + apiKeyHappi
            do{
                let data = try Data(contentsOf: URL(string: url_lyrics)!)
                let tempData = try JSONDecoder().decode(APIResultsLyric.self, from:data)
                lyrics_found = tempData.result.lyrics
            }
            catch{
                print("Data not found")
            }
        }

        return lyrics_found
    }
    
    func play(_ path: String?) {
        if(path == nil){
            return
        }
        do {
            let url = URL(string: path!)!
            let playerItem = AVPlayerItem(url: url)

            player = try AVPlayer(playerItem:playerItem)
            player.volume = 1.0
            player.play()
        } catch {
            print("AVAudioPlayer failed")
        }
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
