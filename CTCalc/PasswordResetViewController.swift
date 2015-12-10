////
////  ParseKeys.swift
////  CTCalc
////
////  Created by Cynthia Whitlatch on 11/16/15.
////  Copyright © 2015 CTC. All rights reserved.
//
//import UIKit
//import Parse
//
//class PasswordResetViewController: UIViewController {
//
//    @IBOutlet weak var emailAddressTextField: UITextField!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
//    
//
//    @IBAction func sendButtonTapped(sender: AnyObject) {
//        
//        let emailAddress = emailAddressTextField.text
//        
//        if emailAddress!.isEmpty
//        {
//           // Display a warning message
//            let userMessage:String = "please type in your email address"
//            displayMessage(userMessage)
//           return
//        }
//        
//        
//        PFUser.requestPasswordResetForEmailInBackground(emailAddress!, block: { (success:Bool, error:NSError?) -> Void in
//         
//            if(error != nil)
//            {
//                let userMessage:String = error!.localizedDescription
//                self.displayMessage(userMessage)
//            } else {
//                let userMessage:String = "An email message was sent to you \(emailAddress)"
//                self.displayMessage(userMessage)
//            }
//            
//        })
//     
//    }
//    
//    func displayMessage(userMessage:String)
//    {
//       let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
//        
//        let okAction = UIAlertAction(title:"OK", style:UIAlertActionStyle.Default) {
//        action in
//            self.dismissViewControllerAnimated(true, completion: nil)
//        }
//        
//        myAlert.addAction(okAction)
//        self.presentViewController(myAlert, animated:true, completion:nil)
//    }
// 
//    @IBAction func cancelButtonTapped(sender: AnyObject) {
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }
//
//}
