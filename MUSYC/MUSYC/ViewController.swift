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
        self.title = "Download"
        view.backgroundColor = UIColor.init(red: 87/255, green: 77/255, blue: 77/255, alpha: 1.0)
        super.viewDidLoad()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
//        numAppear += 1
//        print(numAppear)
//        if(numAppear == 2){
//            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//
//            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "nextView") as! SearchViewController
//            self.present(nextViewController, animated:true, completion:nil)
//        }
    }


}

