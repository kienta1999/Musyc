//
//  SignUpViewController.swift
//  MUSYC
//
//  Created by Su hang on 11/27/20.
//  Copyright © 2020 Anh Le. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase


class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    
    @IBOutlet weak var EmailTextField: UITextField!
    
    @IBOutlet weak var PasswordTextField: UITextField!
    
    @IBOutlet weak var SignUpButton: UIButton!
    
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
    
    // Check the text thing is valid
    func validText()-> String?{
        
        if EmailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" ||
            PasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)==""{
            return "Missing some text fields."
        }
        
        let cleanedEmail = EmailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if others.isValidEmail(email: cleanedEmail) == false{
            return "Please make sure that you follow the correct email format: there's some text bafore @, there's some text after @, there's at least 2 alpha characters after a."
        }
        
        let cleanedPassword = PasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if others.isValidPassword(testStr: cleanedPassword) == false{
            return "Please make sure that you follow the correct password format: at least one uppercase, at least one digit, at least one lowercase, 8 characters total"
        }
        
        
        
        
        return nil
    }
    
    
    
    @IBAction func signUpClicked(_ sender: Any) {
        let error = validText()
        if error != nil{
            errordisp(error!)
        }else{
            
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = EmailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = PasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                if err != nil {
                    self.errordisp("Incorrectly to create the user.")
                }
                else{
                    
                    // create user corrrctly
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["firstname": firstName, "lastname": lastName, "uid":result!.user.uid]) { (error) in
                        
                        if error != nil{
                            self.errordisp("Cannot save user's data.")
                        }
                    }
                    
                    // go back to the homepage
                    self.gobackToHome()
                    
                }
            }
            
        }
        
    }
    
    func errordisp(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func gobackToHome(){
        let HomeViewController = storyboard?.instantiateViewController(identifier: invariable.Storyboard.HomeViewController) as? HomeViewController
        
        view.window?.rootViewController = HomeViewController
        view.window?.makeKeyAndVisible()
    }
    
    
}
