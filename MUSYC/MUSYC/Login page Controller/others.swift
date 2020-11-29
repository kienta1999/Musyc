//
//  others.swift
//  MUSYC
//
//  Created by Su hang on 11/28/20.
//  Copyright © 2020 Anh Le. All rights reserved.
//

import UIKit
import Foundation

class others: UIViewController {

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

    
    // Check if email is valid.
    // refer to http://brainwashinc.com/2017/08/18/ios-swift-3-validate-email-password-format/
     static func isValidEmail(email:String?) -> Bool {
        
        guard email != nil else { return false }
        
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        return pred.evaluate(with: email)
    }
    
    // Check if password is valid,
    // refer to http://brainwashinc.com/2017/08/18/ios-swift-3-validate-email-password-format/
    static func isValidPassword(testStr:String?) -> Bool {
        guard testStr != nil else { return false }

        // at least one uppercase,
        // at least one digit
        // at least one lowercase
        // 8 characters total
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        return passwordTest.evaluate(with: testStr)
    }
}
