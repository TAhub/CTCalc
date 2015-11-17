//
//  ButtonMakerViewController.swift
//  CTCalc
//
//  Created by Cynthia Whitlatch on 11/16/15.
//  Copyright © 2015 CTC. All rights reserved.
//

import UIKit

class ButtonMakerViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var pinkColor: UIButton!
    @IBOutlet weak var greenColor: UIButton!
    @IBOutlet weak var yellowColor: UIButton!
    @IBOutlet weak var orangeColor: UIButton!
    @IBOutlet weak var redColor: UIButton!
    
    @IBOutlet weak var customButtonName: UITextField!
    @IBOutlet weak var customButton: UIImageView!
    
    /////           SAVES BUTTONS TO PARSE
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
    
    @IBAction func saveCustomButton(sender: AnyObject) {
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "github")
        ButtonTableView.uploadButton(image!, imageName: "Hey") { (success) -> () in
            
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
