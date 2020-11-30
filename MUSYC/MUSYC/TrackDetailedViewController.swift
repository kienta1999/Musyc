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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = trackTitle
        
        view.backgroundColor = .white
        
        let imageRatio = CGFloat(1.5)
        let image = getImage(urlImg)
        let theImageFrame = CGRect(x: view.frame.midX - image.size.width / imageRatio / 2 , y: 90, width: image.size.width / imageRatio, height: image.size.height / imageRatio)
        let imageView = UIImageView(frame: theImageFrame)
        imageView.image = image
        
        view.addSubview(imageView)
        
        
        let theNameFrame = CGRect(x: 0, y: image.size.height / imageRatio + 110, width: view.frame.width, height: 30)
        let nameView = UILabel(frame: theNameFrame)
        nameView.text = trackTitle
        nameView.textAlignment = .center
        view.addSubview(nameView)
        
        let theArtistFrame = CGRect(x: 0, y: image.size.height / imageRatio + 140, width: view.frame.width, height: 30)
        let artistView = UILabel(frame: theArtistFrame)
        artistView.text = artist
        artistView.textAlignment = .center
        view.addSubview(artistView)
        
        //play(urlPreview)
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
