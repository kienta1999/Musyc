//
//  MusicPlayer.swift
//  getMusicSample
//
//  Created by Xiaoyu Liu on 12/12/20.
//  Copyright © 2020 Xiaoyu Liu. All rights reserved.
//

import AVFoundation

class MusicPlayer {
//    let levelUpSound = URL(fileURLWithPath: Bundle.main.path(forResource: "levelUp", ofType: "mp3")!)
//    var audioPlayer : AVAudioPlayer!
    static var currentPlayingSound : URL?
    static var audioPlayer = AVAudioPlayer()
    
    static func Play() {
        audioPlayer.play()
    }
    
    static func chooseMusic(url:String) {
        let music = url.components(separatedBy: ".")
        print(music)
//        currentPlayingSound = URL(fileURLWithPath: Bundle.main.path(forResource: music[0], ofType: music[music.count - 1]) ?? "mp3")
        currentPlayingSound = URL(fileURLWithPath: Bundle.main.path(forResource: music[0], ofType: music[music.count - 1]) ?? "mp3")
        audioPlayer.prepareToPlay()
    }

}
