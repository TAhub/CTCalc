//
//  ButtonMakerViewController.swift
//  CTCalc
//
//  Created by Cynthia Whitlatch on 11/16/15.
//  Copyright © 2015 CTC. All rights reserved.
//

import UIKit
import Parse

class ButtonMakerViewController: UIViewController, UITextViewDelegate {
    
    var blueWhitebutton : UIImageView?
    
    @IBOutlet weak var buttonView: UIImageView!
    
    @IBAction func blueWhiteButtonPressed(sender: UIButton) {
        let blueWhiteButton = UIImage(named: "custombutton6")
        buttonView.image = blueWhiteButton
    }
   
    @IBAction func yellowOrangeButton(sender: AnyObject) {
        let blueWhiteButton = UIImage(named: "custombutton4")
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
    
    @IBAction func blueButtonPressed(sender: AnyObject) {
        let blueWhiteButton = UIImage(named: "custombutton1")
        buttonView.image = blueWhiteButton
    }
    
    @IBAction func grayButtonPressed(sender: AnyObject) {
        let blueWhiteButton = UIImage(named: "custombutton5")
        buttonView.image = blueWhiteButton
    }
    

    
            //           SAVES BUTTONS TO PARSE
    func uploadButton(image: UIImage, imageName: String, completion: (success: Bool) -> ()) {
		//   Select the background color you want.  That changes the color of the UIView.   Add up to 5 letters of text/symbols to describe the custom button function.  This will be the "symbol (name)" of the button.
		//to add this to the buttons list
		//let dcvc = navigationController!.parentViewController as! DraggableContainerViewController
		//dcvc.addToken(token:Token)
		//returns a bool; true if it worked, false if you are out of space
		
        if let imageData = UIImageJPEGRepresentation(image, 0.7) {
            let imageFile = PFFile(name: imageName, data: imageData)
            let status = PFObject(className: "ButtomImages")
            status["Image"] = imageFile
            
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
        uploadButton(buttonView.image!, imageName: "image") { (success) -> () in
            if success {
                print("yay")
            }else {
                print("boo")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let loadedNib = NSBundle.mainBundle().loadNibNamed("CalculatorButton", owner: self, options: nil)[0] as! ButtonCollectionViewCell
        
        
//        loadedNib.frame = CGRect(x: 0, y: 0, width: cell.bounds.width, height: cell.bounds.height)
//        loadedNib.label.text = readOnlyButtons[path.row].symbol
//        self.addSubview(self.view)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
