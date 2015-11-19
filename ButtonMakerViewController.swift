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
    
    var pressed = false
    
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var customButtonName: UITextField!
    
    
    @IBAction func redButtonPressed(sender: AnyObject) {
        
    }
    
    @IBAction func orangeButtonPressed(sender: AnyObject) {
    }
    
    
    @IBAction func yellowButtonPressed(sender: AnyObject) {
    }
    
    
    @IBAction func greenButtonPressed(sender: AnyObject) {
    }
    
    
    @IBAction func purpleButtonPressed(sender: AnyObject) {
    }
    
    

    
    //           SAVES BUTTONS TO PARSE
    class func uploadButton(image: UIImage, imageName: String, completion: (success: Bool) -> ()) {
        
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
