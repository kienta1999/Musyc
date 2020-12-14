//
//  LoginPageViewController.swift
//  MUSYC
//
//  Created by Su hang on 11/28/20.
//  Copyright © 2020 Anh Le. All rights reserved.
//

import UIKit

class LoginPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func guestBtn(_ sender: Any) {
        self.performSegue(withIdentifier: "LoginSegue", sender: nil)
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
