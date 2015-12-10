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
        
        let testObject = PFObject(className: "TestObject")
        testObject["foo"] = "bar"
        testObject.saveInBackgroundWithBlock { (success: Bool, error:NSError?) -> Void in
            print("Object Saved")
        }
        
        let userName:String? = NSUserDefaults.standardUserDefaults().stringForKey("user_name")
        
        if(userName != nil) {
            
            //Navigate to Protected Page
        let mainStoryboard = UIStoryboard(name:"Main", bundle:nil)
        var mainPage:MainPageViewController = mainStoryboard.instantiateViewControllerWithIdentifier("MainPageViewController") as! MainPageViewController
        var mainPageNav = UINavigationController(rootViewController: mainPage)
        
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.window?.rootViewController = mainPageNav
            
        }
        
        return true
    }
    
    func setUpParse() {
        Parse.setApplicationId(kParseApplicationId, clientKey: kParseApplicationClientKey)
    }	

    
}
