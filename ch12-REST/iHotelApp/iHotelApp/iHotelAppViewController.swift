//
//  iHotelAppViewController.swift
//  iHotelApp
//
//  Created by WJ on 15/11/2.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class iHotelAppViewController: UIViewController {
    
    var token = ""{
        didSet{
            UserDefaults.standard.setValue(token, forKey: "token")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "iHotel App Demo"
    }
    
    @IBAction func loginButtonTapped() {
        let url = "http://restfulengine.iosptl.com/loginwaiter"

        let user = "mugunth"
        let password = "mugunth"
        
        let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        
        
        Alamofire.request(url, headers: headers)
            .responseJSON { response in
                print(response.description)
                if let error = response.error{
                    let alert = UIAlertController(title: "error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil ))
                    self.present(alert, animated: true , completion: nil)
                    return;
                }
                
             let json = JSON(data: response.data!)
                self.token = json["accessToken"].string!
                let alert = UIAlertController(title: "Success", message: "Login successful", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil ))
                self.present(alert, animated: true , completion: nil)
        }
    }

    @IBAction func fetchMenuItems() {
    }
    
    @IBAction func simulateRequestError() {
        let url = "http://restfulengine.iosptl.com/404"
        let headers = ["Authorization": "Token token=\(token)"]
        
        Alamofire.request(url, headers: headers).responseJSON { (response ) -> Void in
            if let error =  response.result.error {
            
            let alert = UIAlertController(title: "Alert", message: "\(error.localizedDescription)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil ))
            self.present(alert, animated: true , completion: nil)
            }
        }
    }
}
