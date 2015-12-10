//
//  SignupViewController.swift
//  CTCalc
//
//  Created by Cynthia Whitlatch on 12/6/15.
//  Copyright © 2015 CTC. All rights reserved.
//

import UIKit
import Parse

class SignupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var userEmailAddressTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userPasswordRepeatTextField: UITextField!
    @IBOutlet weak var userFirstNameTextField: UITextField!
    @IBOutlet weak var userLastNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        self.edgesForExtendedLayout = UIRectEdge()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func selectProfilePhotoButtonTapped(sender: AnyObject) {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(myPickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        profilePhotoImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func signUpButtonTapped(sender: AnyObject) {
        
        self.view.endEditing(true)
        
        
        let userName = userEmailAddressTextField.text
        let userPassword = userPasswordTextField.text
        let userPasswordRepeat = userPasswordRepeatTextField.text
        let userFirstName = userFirstNameTextField.text
        let userLastName = userLastNameTextField.text
        
        if(userName!.isEmpty || userPassword!.isEmpty || userPasswordRepeat!.isEmpty || userFirstName!.isEmpty || userLastName!.isEmpty)
        {
            let myAlert = UIAlertController(title:"Alert", message:"All fields are required to fill in", preferredStyle:UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
            myAlert.addAction(okAction)
            
            self.presentViewController(myAlert, animated: true, completion: nil)
            
            return
        }
        
        if(userPassword != userPasswordRepeat)
        {
            let myAlert = UIAlertController(title:"Alert", message:"Passwords do not match. Please try again", preferredStyle:UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
            myAlert.addAction(okAction)
            
            self.presentViewController(myAlert, animated: true, completion: nil)
            
            return
        }
        
        let User:PFUser = PFUser()
        User.username = userName
        User.password = userPassword
        User.email = userName
        User.setObject(userFirstName!, forKey: "first_name")
        User.setObject(userLastName!, forKey: "last_name")
        User.setObject(userPassword!, forKey: "password")
        User.setObject(userPasswordRepeat!, forKey: "password_verified")
        User.setObject(userName!, forKey: "email")
        
        let profileImageData = UIImageJPEGRepresentation(profilePhotoImageView.image!, 1)
        if(profileImageData != nil) {
            let profileImageFile = PFFile(data: profileImageData!)
            User.setObject(profileImageFile!, forKey: "profile_picture")
        }
        
        User.signUpInBackgroundWithBlock { (success:Bool, error:NSError?) -> Void in
        
        var userMessage = "Registration is successful. Thank you!"
    
        if(!success)
        {
            userMessage = error!.localizedDescription
        }
            var myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle:UIAlertControllerStyle.Alert)
        
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default){ action in
        
                if(success)
                {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        
            myAlert.addAction(okAction)
            
            self.presentViewController(myAlert, animated: true, completion: nil)
            
        }
    }

}




//
//
//// Show activity indicator
//let spiningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//spiningActivity.labelText = "Sending"
//spiningActivity.detailsLabelText = "Please wait"

//    var myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle:UIAlertControllerStyle.Alert)
//    
//    let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default){ action in
//        
//        if(success)
//        {
//            self.dismissViewControllerAnimated(true, completion: nil)
//        }
//        
//    }
//    
//    myAlert.addAction(okAction)
//    
//    self.presentViewController(myAlert, animated: true, completion: nil)
//    
//}
//
//
//
//}
//}



