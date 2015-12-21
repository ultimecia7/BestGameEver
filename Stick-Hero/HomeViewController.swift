//
//  HomeViewController.swift
//  Stick-Hero
//
//  Created by YIZHONGQI on 11/5/15.
//  Copyright © 2015 koofrank. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class HomeViewController: UIViewController {
    
    var character = ""


    @IBOutlet weak var normal: UIButton!
    
    @IBOutlet weak var DYNum1: UIButton!
    @IBOutlet weak var DYNum2: UIButton!
    @IBOutlet weak var DYNum3: UIButton!
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if(segue.identifier=="normalwdy"){
        // Create a new variable to store the instance of PlayerTableViewController
        let destinationVC = segue.destinationViewController as!GameViewController
        destinationVC.character = character
        }
        else if (segue.identifier == "timewdy"){
            let destinationVC = segue.destinationViewController as!SpeedModeViewController
            destinationVC.character = character
        }
    }
    

    @IBAction func SelectDY1(sender: UIButton) {
        //Deselect
        if(sender.layer.borderWidth > 0)
        {
            sender.layer.borderWidth = 0
        }
        else{
            //select this character and store the selection
            sender.layer.borderWidth = 1.5
            sender.layer.borderColor = UIColor.cyanColor().CGColor
            DYNum2.layer.borderWidth = 0
            DYNum3.layer.borderWidth = 0
            character = "DY#1"
        }
    }
    @IBAction func SelectDY2(sender: UIButton) {
        //Deselect
        if(sender.layer.borderWidth > 0)
        {
            sender.layer.borderWidth = 0
        }
        else{
            //select this character and store the selection
            sender.layer.borderWidth = 1.5
            sender.layer.borderColor = UIColor.redColor().CGColor
            DYNum1.layer.borderWidth = 0
            DYNum3.layer.borderWidth = 0
            character = "DY#2"
        }
    }
    @IBAction func SelectDY3(sender: AnyObject) {
        //Deselect
        if(sender.layer.borderWidth > 0)
        {
            sender.layer.borderWidth = 0
        }
        else{
            //select this character and store the selection
            sender.layer.borderWidth = 1.5
            sender.layer.borderColor = UIColor.orangeColor().CGColor
            DYNum1.layer.borderWidth = 0
            DYNum2.layer.borderWidth = 0
            character = "DY#3"
        }
    }
    @IBAction func sendTextContent(sender: AnyObject) {
         var _scene = Int32(WXSceneSession.rawValue)
        let req = SendMessageToWXReq()
        req.bText = true
        let StoreScoreName = "com.stickHero.score"
        let highScore = NSUserDefaults.standardUserDefaults().integerForKey(StoreScoreName)
        var str = "我是王东源，我在玩 东！源！棍！王！ 我的最高分是："
        str += String(highScore)
        str += " 你也快来玩吧～～～"
        req.text = str
        req.scene = _scene
        WXApi.sendReq(req)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
