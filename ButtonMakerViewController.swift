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
	
	private var token:Token?
	private var tokenView:UIView?
	private func reloadToken()
	{
		token = Token(symbol: symbolTextView.text!, order: kOrderFunc, imageNumber: imageNumber, effect0: nil, effect1: nil, effect2: nil, functionReplace: function)
		
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

    
            //           SAVES BUTTONS TO PARSE
    func uploadButton(completion: (success: Bool) -> ()) {
		
		//add it to your list
		if let token = token
		{
			let dcvc = navigationController!.parentViewController as! DraggableContainerViewController
			print(dcvc.addToken(token))
			
			
			let status = PFObject(className: "ButtomImages")
			status["imageNumber"] = token.imageNumber
			status["symbol"] = token.symbol
			status["function"] = token.functionReplace ?? ""
			
			status.saveInBackgroundWithBlock( { (success, error) -> Void in
				if success {
					completion(success: success)
				} else {
					completion(success: false)
				}
			})
		}
    }
    
    var function:String
	{
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
            uploadButton() { (success) -> () in
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
		reloadToken()
        //        symbolTextView.resignFirstResponder()
        
        return true;
        
    }
}
