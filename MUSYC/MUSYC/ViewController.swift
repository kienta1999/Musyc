//
//  ViewController.swift
//  MUSYC
//
//  Created by Anh Le on 11/16/20.
//  Copyright © 2020 Anh Le. All rights reserved.
//

import UIKit
import SafariServices
import AVFoundation


class ViewController: UIViewController{
//    var auth = SPTAuth.defaultInstance()!
//    var session: SPTSession!
//    var player: SPTAudioStreamingController?
//    var loginUrl: URL?
//    var myplaylists = [SPTPartialPlaylist]()
    struct MusicInfo: Codable{
            var data: [Song]
    //        var url: String
            var code: Int
        }
        
    struct Song : Codable{
    //        var id: Double
            var url: String
    //        var br: Double
    //        var size: Double
    //        var md5: String
    //        var code:Int
    //        var expi: Int
    //        var type: Int
    //        var gain: Int
    //        var fee: Int
    //        var uf:String
    //        var payed: Int
    //        var flag: Int
    //        var canExtend: Bool
    //        var freeTrialInfo: String
    //        var level: String
    //        var encodeType: String
    //        var freeTrialPrivilege: String
    //        var urlSource: Int
        }
    
    var numAppear = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        let url = URL(string:"http://ec2-13-250-43-149.ap-southeast-1.compute.amazonaws.com:3000/song/url?id=462791935&br=999000")
        let data = try! Data(contentsOf: url!)
        let theMusics = try! JSONDecoder().decode(MusicInfo.self, from: data)
//        var music = NSURL(fileURLWithPath: theMusics.data[0].url)
//        player = AVAudioPlayer(contentsOfURL: music, error: nil)
//        player.prepareToPlay()
        
        
        let musicUrl = URL(string:theMusics.data[0].url)
//        let url = URL(string: "http://www.filedownloader.com/mydemofile.pdf")
        MusicDownload.loadFileAsync(url: musicUrl!) { (path, error) in
            print("Music File downloaded to : \(path!)")
//            MusicPlayer.chooseMusic(url: path!)

            MusicPlayer.Play()
        }
    }
    
    
    @IBAction func loginClicked(_ sender: Any) {
        let webVC = WebViewController()
        let url = URL(string: "https://accounts.spotify.com/")!
        let spotifyURLRequest = URLRequest(url: url)
        
        webVC.url = spotifyURLRequest
        webVC.name = "Login"
        
        navigationController?.pushViewController(webVC, animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        numAppear += 1
        print(numAppear)
        if(numAppear == 2){
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "nextView") as! SearchViewController
            self.present(nextViewController, animated:true, completion:nil)
        }
    }
    
//    func setup () {
//        // insert redirect your url and client ID below
//        let redirectURL = "Spotify-Demo://returnAfterLogin" // put your redirect URL here
//        let clientID = "476c620368f349cc8be5b2a29b596eaf" // put your client ID here
//        auth.redirectURL     = URL(string: redirectURL)
//        auth.clientID        = "476c620368f349cc8be5b2a29b596eaf"
//        auth.requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope]
//        loginUrl = auth.spotifyWebAuthenticationURL()
//
////       searchButtn.alpha = 0
//    }


}

