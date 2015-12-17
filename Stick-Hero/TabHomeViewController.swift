//
//  TabHomeViewController.swift
//  Stick-Hero
//
//  Created by YIZHONGQI on 12/18/15.
//  Copyright © 2015 koofrank. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class TabHomeViewController: UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.selectedIndex = 2
    }
    
}