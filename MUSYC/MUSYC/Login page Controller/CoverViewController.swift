//
//  CoverViewController.swift
//  MUSYC
//
//  Created by Su hang on 12/12/20.
//  Copyright © 2020 Anh Le. All rights reserved.
//

import UIKit
import Firebase

class CoverViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

            let user = Auth.auth().currentUser
            if let user = user {
               print("login")
              }
            else{
                print("not login")
                self.performSegue(withIdentifier: "notLoginSegue", sender: nil)
            }

        }
        
        // Do any additional setup after loading the view.
    
    
    @IBAction func SignOutClicked(_ sender: Any) {
    
        let firebaseAuth = Auth.auth()
        do {
            if (UserDefaults.standard.bool(forKey: "loggedIn") != Optional.none) {
                UserDefaults.standard.set(false, forKey: "loggedIn")
            }
          try firebaseAuth.signOut()
         
          self.performSegue(withIdentifier: "notLoginSegue", sender: nil)
            
        } catch let signOutError as NSError {
        print ("Error signing out: %@%@", signOutError)
        }
    }
    

    
    
    }
    
      
      

