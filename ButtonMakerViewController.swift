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
	
	private var imageNumber:Int = 0
	{
		didSet
		{
			reloadToken()
		}
	}
	
	@IBOutlet weak var backer: UIView!
	{
		didSet
		{
			backer.layer.cornerRadius = 10
		}
	}
	
	
	private var token:Token?
	private var tokenView:UIView?
	private func reloadToken()
	{
		if symbolTextView.text!.characters.count >= 5
		{
			symbolTextView.text = symbolTextView.text!.substringToIndex(symbolTextView.text!.startIndex.advancedBy(5))
		}
		
		token = Token(symbol: symbolTextView.text!, order: kOrderFunc, imageNumber: imageNumber, effect0: nil, effect1: nil, effect2: nil, functionReplace: function)
		token!.random = Int(arc4random_uniform(999999))
		
		tokenView?.removeFromSuperview()
		
		//and set the button nib
		let loaded = NSBundle.mainBundle().loadNibNamed("CalculatorButton", owner: self, options: nil)[0] as! ButtonCollectionViewCell
		loaded.frame = CGRect(x: 0, y: 0, width: buttonView.bounds.width, height: buttonView.bounds.height)
		loaded.token = token!
		buttonView.addSubview(loaded)
		tokenView = loaded
	}

    @IBOutlet weak var buttonFunctionLabel: UILabel!
	{
		didSet
		{
			buttonFunctionLabel.text = function
		}
	}
    @IBOutlet weak var symbolTextView: UITextField!
    @IBOutlet weak var buttonView: UIImageView!
    
    @IBAction func blueButtonPressed(sender: AnyObject) {
        imageNumber = 0
    }
    
    @IBAction func orangeButtonPressed(sender: AnyObject) {
        imageNumber = 1
    }
    
    @IBAction func greenButtonPressed(sender: AnyObject) {
        imageNumber = 2
    }
	
    @IBAction func yellowOrangeButton(sender: AnyObject) {
        imageNumber = 3
    }
    
    @IBAction func grayButtonPressed(sender: AnyObject) {
        imageNumber = 4
    }
    
    @IBAction func blueWhiteButtonPressed(sender: UIButton) {
        imageNumber = 5
    }

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		reloadToken()
	}
	
	var dcvc:DraggableContainerViewController!
    
            //           SAVES BUTTONS TO PARSE
    func uploadButton(completion: (success: Bool) -> ()) {
		
		//add it to your list
		if let token = token
		{
			let status = PFObject(className: "Buttons")
			status["imageNumber"] = token.imageNumber
			status["symbol"] = token.symbol
			status["function"] = token.functionReplace ?? ""
			status["random"] = token.random
			status["user"] = PFUser.currentUser()!.objectId
			
			status.saveInBackgroundWithBlock( { (success, error) -> Void in
				if success {
					self.dcvc.addToken(self.token!)
					completion(success: success)
				} else {
					completion(success: false)
				}
			})
		}
    }
    
    var function:String!
	
	var doneCompletion:(()->())!
	@IBAction func cancel(sender: AnyObject)
	{
		doneCompletion()
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
    
    @IBAction func saveCustomButton(sender: AnyObject) {
        if token!.symbol == "" || token!.functionReplace == "" {
            let alertView = UIAlertController(title: "You must enter a Button Name and a Function",
                message: "" as String, preferredStyle:.Alert)
            let okAction = UIAlertAction(title: "Foiled Again!", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: true, completion: nil)
        } else{
            uploadButton() { (success) -> () in
                if success {
					self.cancel(self);
                }else {
					let alertTwo = UIAlertController(title: "Failed to upload button", message: "", preferredStyle: .Alert)
					let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
					alertTwo.addAction(okAction)
					self.presentViewController(alertTwo, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        symbolTextView.delegate = self
    }
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		checkUser(self.view)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
		reloadToken()
        //        symbolTextView.resignFirstResponder()
        
        return true;
        
    }
}
