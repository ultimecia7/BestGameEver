//
//  LoginViewController.swift
//  Stick-Hero
//
//  Created by YIZHONGQI on 11/5/15.
//  Copyright © 2015 koofrank. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation
import SwiftHTTP
import JSONJoy

class LoginViewController: UIViewController {

    @IBOutlet weak var billboard: UILabel!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func login(sender: AnyObject) {
        
        struct Response: JSONJoy {
            let status: String?
            let highscore: String?
            init(_ decoder: JSONDecoder) {
                status = decoder["status"].string
                highscore = decoder["highscore"].string
            }
        }
        
        let params = ["username":"\(username.text!)", "password":"\(password.text!)"]
        
        
        do {
            let opt = try HTTP.POST("http://192.168.1.102/test.php", parameters: params, requestSerializer: JSONParameterSerializer())
            opt.start { response in
                print(response.description)
                if let error = response.error {
                    self.billboard.text = "please check your network"
                    print("got an error: \(error)")
                    return
                }
                let resp = Response(JSONDecoder(response.data))
                
                
                if (resp.status=="true") {
                    print("status: \(resp.status!)")
                    print("highscore: \(resp.highscore!)")
                    
                    dispatch_async(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("login", sender: self)
                    }
                }
                else{
                    self.billboard.text = "invalid password or username"
                    print("status: \(resp.status!)")
                    print("wrong")

                }
            }
        }
        catch let error {
            self.billboard.text = "please try again."
            print("got an error creating the request: \(error)")
        }

        
        
        
        
    }
}
