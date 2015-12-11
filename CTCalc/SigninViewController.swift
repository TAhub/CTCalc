//
//  SigninViewController.swift
//  CTCalc
//
//  Created by Cynthia Whitlatch on 12/6/15.
//  Copyright © 2015 CTC. All rights reserved.
//

import UIKit
import Parse

class SigninViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userEmailAddressTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
 
    @IBAction func signInButtonTapped(sender: AnyObject) {
        
        let userEmail = userEmailAddressTextField.text!
        let userPassword = userPasswordTextField.text!
        
        if (userEmail.isEmpty || userPassword.isEmpty) {
          return
        }
        
        PFUser.logInWithUsernameInBackground(userEmail, password: userPassword) { (user, error) -> Void in
            
            var userMessage = "Welcome!"
            
            if(user != nil) {
                
                let userName:String? = user?.username
                
                NSUserDefaults.standardUserDefaults().setObject(userName, forKey: "user_name")
                NSUserDefaults.standardUserDefaults().synchronize()
                
                let mainStoryboard = UIStoryboard(name:"Main", bundle:nil)
                
                let mainPage:MainPageViewController = mainStoryboard.instantiateViewControllerWithIdentifier("MainPageViewController") as! MainPageViewController
                
                let mainPageNav = UINavigationController(rootViewController: mainPage)
                
                let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                appDelegate.window?.rootViewController = mainPageNav
                
            } else {
                
                userMessage = error!.localizedDescription
            }
            
            let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
            myAlert.addAction(action)
            
            self.presentViewController(myAlert, animated: true, completion:nil)
        }
    }
}