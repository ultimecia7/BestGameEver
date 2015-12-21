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

class ContactViewController: UITableViewController {

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

    
    var friends = [ArrayElement]()
    var test : [String] = ["aaa","bbbb"]
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!;
        let params = ["username":"root"]
        do {
            let opt = try HTTP.POST("http://192.168.1.107/friend_info.php", parameters: params, requestSerializer: JSONParameterSerializer())
            opt.start { response in
                print(response.description)
                if let error = response.error {
                    print("got an error: \(error)")
                    return
                }
                let resp = ArrayResponse(JSONDecoder(response.data))
                for var friend in resp.friendList!{
                    self.friends.append(ArrayElement(friend))
                }
                self.tableView.reloadData()
                print(self.friends)
            }
        }
        catch let error {
            print("got an error creating the request: \(error)")
        }

    }
    
    
    override func viewDidLoad() {
        
        
        self.tableView.reloadData()
        super.viewDidLoad()
        print("asdhjashdkashdkashdkjhas")
        print(self.friends.count)
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friends.count;
        //return test.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("myCustomCell", forIndexPath: indexPath) as! ContactTableViewCell

        ///*
        let friend = self.friends[indexPath.row]
        cell.user.text = friend.username!
        cell.normalhigh.text = friend.highscore!
        cell.speedhigh.text = friend.speed_highscore!
        //*/
        /*
        let testcell = test[indexPath.row]
        cell.user.text = testcell
        */
        print("asdasdasdcxvegfdgdfgfdgxcvw")
        return cell
    }
    
    
}
