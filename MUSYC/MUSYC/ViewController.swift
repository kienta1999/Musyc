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
    
    var numAppear = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

