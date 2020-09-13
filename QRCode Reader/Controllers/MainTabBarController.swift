//
//  MainViewController.swift
//  QRCode Reader
//
//  Created by Jaelhorton on 8/29/20.
//  Copyright © 2020 qrcodereader. All rights reserved.
//

import UIKit
import SwipeableTabBarController

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        /// Set the animation type for swipe
        swipeAnimatedTransitioning?.animationType = SwipeAnimationType.sideBySide
        
        /// Set the animation type for tap
        tapAnimatedTransitioning?.animationType = SwipeAnimationType.push

        /// if you want cycling switch tab, set true 'isCyclingEnabled'
        isCyclingEnabled = true
        */
        self.tabBar.tintColor = UIColor.white
        
    }
    



}
