//
//  FavouriteViewController.swift
//  MUSYC
//
//  Created by Anh Le on 12/13/20.
//  Copyright © 2020 Anh Le. All rights reserved.
//

import UIKit

class FavouriteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let keyFavTrack:String = "keyFavTrack"
    let keyArtist = "keyArtist"
    let keyImage: String = "keyImage"
    let keyUri = "keyUri"
    
    var favTrack:[String] = [] {
        didSet{
            favouriteTrackTable.reloadData()
        }
    }
    var favArtist:[String] = []
    var favImageUrl:[String] = []
    var favUri:[String] = []
    
    
    @IBOutlet weak var favouriteTrackTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        favouriteTrackTable.register(UITableViewCell.self, forCellReuseIdentifier: "theCell")
        favouriteTrackTable.dataSource = self
        favouriteTrackTable.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.array(forKey: self.keyFavTrack) == nil {
            UserDefaults.standard.set([], forKey: self.keyFavTrack)
        }
        if UserDefaults.standard.array(forKey: self.keyArtist) == nil {
            UserDefaults.standard.set([], forKey: self.keyArtist)
        }
        if UserDefaults.standard.array(forKey: self.keyImage) == nil {
            UserDefaults.standard.set([], forKey: self.keyImage)
        }
        if UserDefaults.standard.array(forKey: self.keyUri) == nil {
            UserDefaults.standard.set([], forKey: self.keyUri)
        }
        
        favTrack = UserDefaults.standard.array(forKey: self.keyFavTrack)! as? [String] ?? []
        favArtist = UserDefaults.standard.array(forKey: self.keyArtist)! as? [String] ?? []
        favImageUrl = UserDefaults.standard.array(forKey: self.keyImage)! as? [String] ?? []
        favUri = UserDefaults.standard.array(forKey: self.keyUri)! as? [String] ?? []
    }
    
    func getTrackDetail(_ track: String, _ artist: String) -> String {
        return track + " (" + artist + ")"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favTrack.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "theCell")! as UITableViewCell
        
        
        myCell.textLabel!.text = getTrackDetail(favTrack[indexPath.row], favArtist[indexPath.row])
        
        return myCell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete{
                let title = tableView.cellForRow(at: indexPath)?.textLabel!.text
                for i in 0 ..< self.favTrack.count {
                    if(getTrackDetail(self.favTrack[indexPath.row], self.favArtist[indexPath.row]) == title){
                        
                        self.favTrack.remove(at: i)
                        self.favArtist.remove(at: i)
                        self.favImageUrl.remove(at: i)
                        self.favUri.remove(at: i)
                        
                        UserDefaults.standard.set(favTrack, forKey: self.keyFavTrack)
                        UserDefaults.standard.set(favArtist, forKey: self.keyArtist)
                        UserDefaults.standard.set(favImageUrl, forKey: self.keyImage)
                        UserDefaults.standard.set(favUri, forKey: self.keyUri)
                        
                        break
                    }
                }
    //            tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let detailedVC = TrackDetailedViewController()
            let index = indexPath.row
            detailedVC.trackTitle = favTrack[index]
            detailedVC.artist = favArtist[index]
            detailedVC.urlImg = favImageUrl[index]
            detailedVC.uri = favImageUrl[index]
            self.navigationController?.pushViewController(detailedVC, animated: true)
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
