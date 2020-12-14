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
        
        
        view.backgroundColor = UIColor.init(red: 87/255, green: 77/255, blue: 77/255, alpha: 1.0)
        // Do any additional setup after loading the view.
        self.title = "Favourite Songs"
        favouriteTrackTable.register(UITableViewCell.self, forCellReuseIdentifier: "theCell")
        favouriteTrackTable.dataSource = self
        favouriteTrackTable.delegate = self
        favouriteTrackTable.backgroundColor = UIColor.init(red: 87/255, green: 77/255, blue: 77/255, alpha: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //add a check so if user not logged in, jump to log in page
        if (UserDefaults.standard.bool(forKey: "loggedIn") == Optional.none || !UserDefaults.standard.bool(forKey: "loggedIn")) {
            UserDefaults.standard.set(false, forKey: "loggedIn")
            let alert = UIAlertController(title: "Please Login", message: "You have to log in so you can use Favorite List", preferredStyle: UIAlertController.Style.alert)
                       alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.performSegue(withIdentifier: "SignUpSegue", sender: nil)

        }
        
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
        myCell.backgroundColor = UIColor.init(red: 87/255, green: 77/255, blue: 77/255, alpha: 1.0)
//        DispatchQueue.main.async{
//            myCell.imageView?.image = self.getImage(self.favImageUrl[indexPath.row])
//        }
        myCell.imageView?.image = self.getImage(self.favImageUrl[indexPath.row])
        myCell.textLabel!.text = getTrackDetail(favTrack[indexPath.row], favArtist[indexPath.row])
        myCell.textLabel!.textColor = .white
        
        return myCell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete{
                let title = tableView.cellForRow(at: indexPath)?.textLabel!.text
                for i in 0 ..< self.favTrack.count {
                    if(getTrackDetail(self.favTrack[i], self.favArtist[i]) == title){
                        
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
            detailedVC.uri = favUri[index]
            self.navigationController?.pushViewController(detailedVC, animated: true)
        }
    
    func getImage(_ path: String) -> UIImage{
        let url = URL(string: path)
        let data = try? Data(contentsOf: url!)
        if(data == nil){
            return UIImage(named: "image-not-found")!
        }
        return UIImage(data: data!)!
    }
    
    
    @IBAction func clearAllFavorite(_ sender: Any) {
        UserDefaults.standard.set([], forKey: self.keyFavTrack)
        UserDefaults.standard.set([], forKey: self.keyArtist)
        UserDefaults.standard.set([], forKey: self.keyImage)
        UserDefaults.standard.set([], forKey: self.keyUri)
        favTrack = []
        favArtist = []
        favImageUrl = []
        favUri = []
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
