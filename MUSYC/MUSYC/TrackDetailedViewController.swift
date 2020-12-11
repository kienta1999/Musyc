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
        
        view.backgroundColor = .black
        
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
        lyricView.text = "We don't talk anymore, we don't talk anymore\r\nWe don't talk anymore, like we used to do\r\nWe don't love anymore\r\nWhat was all of it for?\r\nOh, we don't talk anymore, like we used to do\r\n\r\nI just heard you found the one you've been looking\r\nYou've been looking for\r\nI wish I would have known that wasn't me\r\n'Cause even after all this time I still wonder\r\nWhy I can't move on\r\nJust the way you did so easily\r\n\r\nDon't wanna know\r\nWhat kind of dress you're wearing tonight\r\nIf he's holding onto you so tight\r\nThe way I did before\r\nI overdosed\r\nShould've known your love was a game\r\nNow I can't get you out of my brain\r\nOh, it's such a shame\r\n\r\nThat we don't talk anymore, we don't talk anymore\r\nWe don't talk anymore, like we used to do\r\nWe don't love anymore\r\nWhat was all of it for?\r\nOh, we don't talk anymore, like we used to do\r\n\r\nI just hope you're lying next to somebody\r\nWho knows how to love you like me\r\nThere must be a good reason that you're gone\r\nEvery now and then I think you\r\nMight want me to come show up at your door\r\nBut I'm just too afraid that I'll be wrong\r\n\r\nDon't wanna know\r\nIf you're looking into her eyes\r\nIf she's holding onto you so tight the way I did before\r\nI overdosed\r\nShould've known your love was a game\r\nNow I can't get you out of my brain\r\nOh, it's such a shame\r\n\r\nThat we don't talk anymore (We don't, we don't)\r\nWe don't talk anymore (We don't, we don't)\r\nWe don't talk anymore, like we used to do\r\nWe don't love anymore (We don't, we don't)\r\nWhat was all of it for? (We don't, we don't)\r\nOh, we don't talk anymore, like we used to do\r\n\r\nLike we used to do\r\n\r\nDon't wanna know\r\nWhat kind of dress you're wearing tonight\r\nIf he's giving it to you just right\r\nThe way I did before\r\nI overdosed\r\nShould've known your love was a game\r\nNow I can't get you out of my brain\r\nOh, it's such a shame\r\n\r\nThat we don't talk anymore (We don't, we don't)\r\nWe don't talk anymore (We don't, we don't)\r\nWe don't talk anymore, like we used to do\r\nWe don't love anymore (We don't, we don't)\r\nWhat was all of it for? (We don't, we don't)\r\nOh, we don't talk anymore, like we used to do\r\n\r\nWe don't talk anymore, oh, oh\r\n(What kind of dress you're wearing tonight)\r\n(If he's holding onto you so tight)\r\nThe way I did before\r\nWe don't talk anymore, oh, woah\r\n(Should've known your love was a game)\r\n(Now I can't get you out of my brain)\r\nOoh, it's such a shame\r\nThat we don't talk anymore"
        lyricView.textColor = .white
        lyricView.font = UIFont.boldSystemFont(ofSize: 16)
        lyricView.backgroundColor = .clear
        lyricView.isEditable = false
        lyricView.isScrollEnabled = true
        view.addSubview(lyricView)
        
        
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
