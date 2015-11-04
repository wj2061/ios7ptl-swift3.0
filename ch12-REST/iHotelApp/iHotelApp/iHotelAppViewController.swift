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
            NSUserDefaults.standardUserDefaults().setValue(token, forKey: "token")
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
        
        let credentialData = "\(user):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Credentials = credentialData.base64EncodedStringWithOptions([])
        
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        
        Alamofire.request(.GET, url, headers: headers)
            .responseJSON { response in
                print(response.description)
             let json = JSON(data: response.data!)
                self.token = json["accessToken"].string!
                let alert = UIAlertController(title: "Success", message: "Login successful", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil ))
                self.presentViewController(alert, animated: true , completion: nil)
        }
    }

    @IBAction func fetchMenuItems() {
    }
    
    @IBAction func simulateRequestError() {
        let url = "http://restfulengine.iosptl.com/404"
        let headers = ["Authorization": "Token token=\(token)"]
        
        Alamofire.request(.GET, url, headers: headers).responseJSON { (response ) -> Void in
            if let error =  response.result.error {
            
            let alert = UIAlertController(title: "Alert", message: "\(error.localizedDescription)", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil ))
            self.presentViewController(alert, animated: true , completion: nil)
            }
        }
    }
}
