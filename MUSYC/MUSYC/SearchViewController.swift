//
//  SearchViewController.swift
//  MUSYC
//
//  Created by Kien Ta on 11/26/20.
//  Copyright © 2020 Anh Le. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

      
        struct Token: Decodable {
          let access_token: String
      }

        //let client_id = "4c4b5879f3d74b2fac7b995cca064abd";
        //let client_secret = "027be414fc074154aa5bbe847fe2f354"

        var access_token = "not-available";
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
            let access_token = getAccessToken()
            print(access_token)
            
        }
        
        
        func getAccessToken() -> String{
            let refresh_token = "AQBcAsJod-8i1B13F9DI1ylAMfcpQykIyXnzjvfdXStdzeANmgYc3e_DbqxI4GqOIQEarRx4ShPKngC3KWtyv_f3NO2macj_J7ph_g0A4wLQ-DOL3ke5t5W4xbvOTmKrhYE";
            let encoded_64_id_secret = "NGM0YjU4NzlmM2Q3NGIyZmFjN2I5OTVjY2EwNjRhYmQ6MDI3YmU0MTRmYzA3NDE1NGFhNWJiZTg0N2ZlMmYzNTQ=";
            var ans = "error"
            let url = URL(string: "https://accounts.spotify.com/api/token")!
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!

            components.queryItems = [
                URLQueryItem(name: "grant_type", value: "refresh_token"),
                URLQueryItem(name: "refresh_token", value: refresh_token)
    //            ,URLQueryItem(name: "client_id", value: client_id)
    //            ,URLQueryItem(name: "client_secret", value: client_secret)
            ]

            let query = components.url!.query
            
            var request = URLRequest(url: url)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("Basic " + encoded_64_id_secret, forHTTPHeaderField: "Authorization")
            request.httpMethod = "POST"
            request.httpBody = Data(query!.utf8)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data,
                    let response = response as? HTTPURLResponse,
                    error == nil else {                                              // check for fundamental networking error
                    print("error", error ?? "Unknown error")
                    return
                }

                guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                    print("statusCode should be 2xx, but is \(response.statusCode)")
                    print("response = \(response)")
                    return
                }

                let responseString = String(data: data, encoding: .utf8)
                //self.access_token = responseString!.components(separatedBy: "\"")[3]
                ans = responseString!.components(separatedBy: "\"")[3]
            }
            task.resume()
            sleep(1)
            return ans
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
