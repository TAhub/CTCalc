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
//    var drawerContainer: MMDrawerController?
   
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        setUpParse()
        
        let pageController = UIPageControl.appearance()
        pageController.pageIndicatorTintColor = UIColor.lightGrayColor()
        pageController.currentPageIndicatorTintColor = UIColor.blackColor()
        pageController.backgroundColor = UIColor.whiteColor()
        
        let userNotificationTypes: UIUserNotificationType = ([UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound]);
        
        let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
        application.registerUserNotificationSettings(settings)
        
        application.registerForRemoteNotifications()
        
        
        buildUserInterface()
        
        return true
    }
    
    func setUpParse() {
        Parse.setApplicationId(kParseApplicationId, clientKey: kParseApplicationClientKey)
    }	
    func buildUserInterface() {
        
        let userName:String? =  NSUserDefaults.standardUserDefaults().stringForKey("user_name")
        
        if(userName != nil)
        {
            let mainStoryBoard:UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
            
            var mainPage:MainPageViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("MainPageViewController") as! MainPageViewController
            
            var mainPageNav = UINavigationController(rootViewController:mainPage)

        }
    }
}
