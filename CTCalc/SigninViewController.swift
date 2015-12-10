//
//  ViewController.swift
//  MyNewApp
//
//  Created by Sergey Kargopolov on 2015-06-04.
//  Copyright (c) 2015 Sergey Kargopolov. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    @IBOutlet weak var userEmailAddressTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    @IBAction func signInButtonTapped(sender: AnyObject) {
        
        let userEmail = userEmailAddressTextField.text
        let userPassword = userPasswordTextField.text
        
        if(userEmail.isEmpty || userPassword.isEmpty)
        {
          return
        }
        
        
        let spiningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        spiningActivity.labelText = "Sending"
        spiningActivity.detailsLabelText = "Please wait"
        //spiningActivity.userInteractionEnabled = false
        
        
        PFUser.logInWithUsernameInBackground(userEmail, password: userPassword) { (user:PFUser?, error:NSError?) -> Void in
            
           MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    
            
            var userMessage = "Welcome!"
            
            if(user != nil)
            {
                
                // Remember the sign in state
                let userName:String? = user?.username
                
                NSUserDefaults.standardUserDefaults().setObject(userName, forKey: "user_name")
                NSUserDefaults.standardUserDefaults().synchronize()
                
                // Navigate to Protected page
               
                var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                 appDelegate.buildUserInterface()
                
              
                
            } else {
                
                userMessage = error!.localizedDescription
                var myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
                
                let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                
                myAlert.addAction(okAction)
                
                self.presentViewController(myAlert, animated: true, completion: nil)
            }
        
            
        }
        
        
    }
    
    @IBAction func facebookButtonTapped(sender: AnyObject) {
        
        let permissions = ["public_profile","email"]
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions, block: { (user:PFUser?, error:NSError?) -> Void in
            
            if(error != nil)
            {
              // display an error message 
                let userMessage = error!.localizedDescription
                var myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
                
                let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                
                myAlert.addAction(okAction)
                
                self.presentViewController(myAlert, animated: true, completion: nil)
                return
            }            
            // Load facebook details like user First name, User last name, email address, profile picture. 
            self.loadFacebookUserDetails()
            
            
        })
        
    }
    
    func loadFacebookUserDetails()
    {
        
        // Show activity indicator
        let spiningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        spiningActivity.labelText = "Loading"
        spiningActivity.detailsLabelText = "Please wait"
        
        
        // Define fields we would like to read from Facebook User object
        var requestParameters = ["fields": "id, email, first_name, last_name, name"]
        
        // /me
        let userDetails = FBSDKGraphRequest(graphPath: "me", parameters: requestParameters)
       
        userDetails.startWithCompletionHandler({
            (connection, result, error: NSError!) -> Void in
        
            if error != nil {
                
                // Display error message
                spiningActivity.hide(true)
                
                let userMessage = error!.localizedDescription
                var myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
                
                let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                
                myAlert.addAction(okAction)
                
                self.presentViewController(myAlert, animated: true, completion: nil)
                
                PFUser.logOut()
                
                return
            }
            
            // Extract user fields
            let userId:String = result["id"] as! String
            let userFullName:String = result["name"] as! String
            var userEmail:String? = result["email"] as? String
            let userFirstName:String?  = result["first_name"] as? String
            let userLastName:String? = result["last_name"] as? String
            
            // Get Facebook profile picture
            var userProfile = "https://graph.facebook.com/" + userId + "/picture?type=large"
            
            let profilePictureUrl = NSURL(string: userProfile)
            
            let profilePictureData = NSData(contentsOfURL: profilePictureUrl!)
            
            // Prepare PFUser object
            if(profilePictureData != nil)
            {
                let profileFileObject = PFFile(data:profilePictureData!)
                PFUser.currentUser()?.setObject(profileFileObject, forKey: "profile_picture")
            }
            
            PFUser.currentUser()?.setObject(userFirstName!, forKey: "first_name")
            PFUser.currentUser()?.setObject(userLastName!, forKey: "last_name")
            
            
            if let userEmail = userEmail
            {
                PFUser.currentUser()?.email = userEmail
                PFUser.currentUser()?.username = userEmail
            }
            
            
            
            PFUser.currentUser()?.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
               
               spiningActivity.hide(true)
                
                if(error != nil)
                {
                    let userMessage = error!.localizedDescription
                    var myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
                    
                    let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                    
                    myAlert.addAction(okAction)
                    
                    self.presentViewController(myAlert, animated: true, completion: nil)
                    
                    
                    PFUser.logOut()
                    return
    
                }
                
                
                if(success)
                {
                    if !userId.isEmpty
                    {
                        NSUserDefaults.standardUserDefaults().setObject(userId, forKey: "user_name")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                            appDelegate.buildUserInterface()
                        }
                        
                    }
                    
                }

                
                
                
                
                
                
            })
            
            
            
        })
    }
    
    
}

