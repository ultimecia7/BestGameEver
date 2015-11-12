//
//  SignupViewController.swift
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

class SignupViewController: UIViewController {

    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatpasswordTextField: UITextField!

    @IBAction func Signup() {
        //Send json (test)
        
        struct Response: JSONJoy {
            let status: String?
            let error: String?
            init(_ decoder: JSONDecoder) {
                status = decoder["status"].string
                error = decoder["error"].string
            }
        }
        
        print("\(accountTextField.text!)")
        print("\(passwordTextField.text!)")
        
        
        let params = ["username":"\(accountTextField.text!)", "password":"\(passwordTextField.text!)"]
        
        
        do {
            let opt = try HTTP.POST("http://192.168.1.102/testreg.php", parameters: params, requestSerializer: JSONParameterSerializer())
            opt.start { response in
                print(response.description)
                if let error = response.error {
                    print("got an error: \(error)")
                    return
                }
                let resp = Response(JSONDecoder(response.data))
                if let err = resp.error {
                    print("got an error: \(err)")
                }
                if let status = resp.status {
                    print("completed: \(status)")
                }
            }
        }
        catch let error {
            print("got an error creating the request: \(error)")
        }

    }
}
