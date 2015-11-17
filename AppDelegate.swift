//
//  AppDelegate.swift
//  CTCalc
//
//  Created by Theodore Abshire on 11/13/15.
//  Copyright © 2015 CTC. All rights reserved.
//

import UIKit
import Parse
import Bolts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
   
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        setUpParse()
        return true
    }
    
    func setUpParse() {
        Parse.setApplicationId(kParseApplicationId, clientKey: kParseApplicationClientKey)
    }	

}

