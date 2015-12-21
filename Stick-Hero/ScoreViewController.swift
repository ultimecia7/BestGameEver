//
//  ScoreViewController.swift
//  Stick-Hero
//
//  Created by YIZHONGQI on 11/12/15.
//  Copyright © 2015 koofrank. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class ScoreViewController: UIViewController {
    
    @IBOutlet weak var highScore: UILabel!
    
    @IBOutlet weak var speedHighScore: UILabel!
    
    @IBOutlet weak var user: UILabel!
    
    let StoreScoreName = "com.stickHero.score"
    let StoreSpeedScoreName = "com.stickHero.speedscore"
    let StoreLoginUser = "com.stickHero.user"
    
    override func viewDidLoad() {
        
        let userName = NSUserDefaults.standardUserDefaults().valueForKey(StoreLoginUser)
        let highscore : Int? = NSUserDefaults.standardUserDefaults().integerForKey(StoreScoreName)
        let speedhighscore : Int? = NSUserDefaults.standardUserDefaults().integerForKey(StoreSpeedScoreName)
        
        if(userName == nil){
            self.user.text = "guest"
           
        }
        else{
             self.user.text = userName! as! String
            print(userName!)
        }
        
        if(highscore != nil){
            self.highScore.text = String(highscore!)
        }
        else{
            self.highScore.text = "No"
        }
        
        if(speedhighscore != nil){
            self.speedHighScore.text = String(speedhighscore!)
        }
        else{
            self.speedHighScore.text = "No"
        }
        
    }
}