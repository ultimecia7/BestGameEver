//
//  SpeedModeViewController.swift
//  Stick-Hero
//
//  Created by 刘嘉诚 on 11/12/15.
//  Copyright © 2015 koofrank. All rights reserved.
//


import UIKit
import SpriteKit
import AVFoundation

class SpeedModeViewController: UIViewController {
    
    @IBAction func timeback(sender: AnyObject) {
        //TODO: send a request to sever
        
        self.performSegueWithIdentifier("speedback", sender: self)
    }
    
    @IBOutlet weak var display: UILabel!
    var musicPlayer:AVAudioPlayer!
    var character:String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(character)
        let scene = SpeedModeScene(size:CGSizeMake(DefinedScreenWidth, DefinedScreenHeight))
        scene.Character = character
        
        // Configure the view.
        let skView = self.view as! SKView
        //        skView.showsFPS = true
        //        skView.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        
        skView.presentScene(scene)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        musicPlayer = setupAudioPlayerWithFile("bg_country", type: "mp3")
        musicPlayer.numberOfLoops = -1
        musicPlayer.play()
    }
    
    
    func setupAudioPlayerWithFile(file:NSString, type:NSString) -> AVAudioPlayer  {
        let url = NSBundle.mainBundle().URLForResource(file as String, withExtension: type as String)
        var audioPlayer:AVAudioPlayer?
        
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: url!)
        } catch {
            print("NO AUDIO PLAYER")
        }
        
        return audioPlayer!
    }
    
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    

    
}