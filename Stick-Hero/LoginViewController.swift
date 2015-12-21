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
            let speedhighscore: String?
            init(_ decoder: JSONDecoder) {
                status = decoder["status"].string
                highscore = decoder["highscore"].string
                speedhighscore = decoder["speedhighscore"].string
            }
        }
        
        let params = ["username":"\(username.text!)", "password":"\(password.text!)"]
        
        
        do {
            let opt = try HTTP.POST("http://192.168.1.102/login.php", parameters: params, requestSerializer: JSONParameterSerializer())
            opt.start { response in
                print(response.description)
                if let error = response.error {
                    self.billboard.text = "please check your network"
                    print("got an error: \(error)")
                    return
                }
                let resp = Response(JSONDecoder(response.data))
                
                
                if (resp.status=="true") {
                    let StoreScoreName = "com.stickHero.score"
                    let StoreSpeedScoreName = "com.stickHero.speedscore"
                    let StoreLoginUser = "com.stickHero.user"
                    let hsVar1 : String = resp.highscore!
                    let user_highscore:Int? = Int(hsVar1)
                    NSUserDefaults.standardUserDefaults().setInteger(user_highscore!, forKey: StoreScoreName)
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    let hsVar2 : String = resp.speedhighscore!
                    let user_speedhighscore:Int? = Int(hsVar2)
                    NSUserDefaults.standardUserDefaults().setInteger(user_speedhighscore!, forKey: StoreSpeedScoreName)
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    let userVar : String = self.username.text!
                    NSUserDefaults.standardUserDefaults().setValue(userVar, forKey: StoreLoginUser)
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    let userName = NSUserDefaults.standardUserDefaults().valueForKey(StoreLoginUser)
                    
                    print(userName!)
                    print(userVar)
                    print("status: \(resp.status!)")
                    print("highscore: \(resp.highscore!)")
                    
                    dispatch_async(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("logintab", sender: self)
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
