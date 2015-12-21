//
//  ContactViewController.swift
//  Stick-Hero
//
//  Created by 徐静恺 on 12/21/15.
//  Copyright © 2015 koofrank. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation
import SwiftHTTP
import JSONJoy

class ContactViewController: UITableViewController{
    
    struct ArrayResponse: JSONJoy{
        let friendList: Array<JSONDecoder>?
        init(_ decoder: JSONDecoder) {
            friendList = decoder["friendList"].array
        }
    }
    
    struct ArrayElement: JSONJoy{
        let username : String?
        let highscore: String?
        let speed_highscore: String?
        let online: String?
        let last_login_time: String?
        init(_ decoder: JSONDecoder) {
            username = decoder["username"].string
            highscore = decoder["highscore"].string
            speed_highscore = decoder["speed_highscore"].string
            online = decoder["online"].string
            last_login_time = decoder["last_login_time"].string
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let params = ["username":"root"]
        do {
            let opt = try HTTP.POST("http://192.168.1.102/friend_info.php", parameters: params, requestSerializer: JSONParameterSerializer())
            opt.start { response in
                print(response.description)
                if let error = response.error {
                    print("got an error: \(error)")
                    return
                }
                let resp = ArrayResponse(JSONDecoder(response.data))
                for var friend in resp.friendList!{
                    let str = ArrayElement(friend)
                    
                }
                            }
        }
        catch let error {
            print("got an error creating the request: \(error)")
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.selectedIndex = 2
    }
    
}
