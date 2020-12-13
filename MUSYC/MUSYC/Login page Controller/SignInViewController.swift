//
//  SignInViewController.swift
//  MUSYC
//
//  Created by Su hang on 11/27/20.
//  Copyright © 2020 Anh Le. All rights reserved.
//

import UIKit
import FirebaseAuth


class SignInViewController: UIViewController {

    @IBOutlet weak var emailAddressTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!

    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBAction func logInClicked(_ sender: Any) {
        
        let email = emailAddressTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        // User sign in
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil{
                //cannot sign in
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }
            else{
                self.performSegue(withIdentifier: "LoginSegue", sender: nil)
//                let HomeViewController = self.storyboard?.instantiateViewController(identifier: invariable.Storyboard.HomeViewController) as? HomeViewController
//
//
//                //PlayVC
//                self.view.window?.rootViewController = ViewController
//                self.view.window?.makeKeyAndVisible()
            }
            
        }
        
    }
    
    
}
