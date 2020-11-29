//
//  TrackDetailedViewController.swift
//  MUSYC
//
//  Created by Kien Ta on 11/30/20.
//  Copyright © 2020 Anh Le. All rights reserved.
//

import UIKit

class TrackDetailedViewController: UIViewController {
    
    var trackTitle: String!
    var urlImg: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("here")
        
        let image = getImage(urlImg)
        let imageRatio = 1
        let theTextFrame = CGRect(x: 0, y: image.size.height / CGFloat(imageRatio) + 110, width: view.frame.width, height: 30)
       let textView = UILabel(frame: theTextFrame)
       textView.text = "Title: " + trackTitle
       textView.textAlignment = .center
       view.addSubview(textView)
    }
    
    func getImage(_ path: String) -> UIImage{
           let url = URL(string: path)
           let data = try? Data(contentsOf: url!)
//           if(data == nil){
//               return UIImage(named: "img_not_found")!
//           }
        return UIImage(data: data!)!
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
