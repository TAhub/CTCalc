//
//  ButtonMakerViewController.swift
//  CTCalc
//
//  Created by Cynthia Whitlatch on 11/16/15.
//  Copyright © 2015 CTC. All rights reserved.
//

import UIKit
import Parse

class ButtonMakerViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    var blueWhitebutton : UIImageView?

    @IBOutlet weak var buttonFunctionLabel: UILabel!
    @IBOutlet weak var symbolTextView: UITextField! {
        didSet {
            buttonFunctionLabel.text = function
        }
    }
    @IBOutlet weak var buttonView: UIImageView!
    
    @IBAction func blueButtonPressed(sender: AnyObject) {
        let blueWhiteButton = UIImage(named: "custombutton1")
        buttonView.image = blueWhiteButton
    }
    
    @IBAction func orangeButtonPressed(sender: AnyObject) {
        let blueWhiteButton = UIImage(named: "custombutton2")
        buttonView.image = blueWhiteButton
    }
    
    @IBAction func greenButtonPressed(sender: AnyObject) {
        let blueWhiteButton = UIImage(named: "custombutton3")
        buttonView.image = blueWhiteButton
    }
   
    @IBAction func yellowOrangeButton(sender: AnyObject) {
        let blueWhiteButton = UIImage(named: "custombutton4")
        buttonView.image = blueWhiteButton
    }
    
    @IBAction func grayButtonPressed(sender: AnyObject) {
        let blueWhiteButton = UIImage(named: "custombutton5")
        buttonView.image = blueWhiteButton
    }
    
    @IBAction func blueWhiteButtonPressed(sender: UIButton) {
        let blueWhiteButton = UIImage(named: "custombutton6")
        buttonView.image = blueWhiteButton
    }

    
            //           SAVES BUTTONS TO PARSE
    func uploadButton(image: UIImage, imageName: String, symbol:String, completion: (success: Bool) -> ()) {
        if let imageData = UIImageJPEGRepresentation(image, 0.7) {
            let imageFile = PFFile(name: imageName, data: imageData)
            let status = PFObject(className: "ButtomImages")
            status["Image"] = imageFile
            status["symbol"] = symbol
            
            status.saveInBackgroundWithBlock( { (success, error) -> Void in
                if success {
                    completion(success: success)
                } else {
                    completion(success: false)
                }
            })
        }
    }
    
    var function:String {
        let dcvc = navigationController!.parentViewController as! DraggableContainerViewController
            let calc = dcvc.viewControllers[0] as! CalculatorCollectionViewController
            return calc.calculator.functionString
    }
    
    @IBAction func saveCustomButton(sender: AnyObject) {
        if symbolTextView.text == "" {
            let alertView = UIAlertController(title: "You must enter a Button Name and a Function",
                message: "" as String, preferredStyle:.Alert)
            let okAction = UIAlertAction(title: "Foiled Again!", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: true, completion: nil)
        } else{
            uploadButton(buttonView.image!, imageName: "image", symbol: symbolTextView.text!) { (success) -> () in
                if success {
                    print("yay")
                }else {
                    print("boo")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        symbolTextView.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        //        symbolTextView.resignFirstResponder()
        
        return true;
        
    }
}
