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

class ContactViewController: UITableViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("shit")
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.selectedIndex = 2
    }
    
}
