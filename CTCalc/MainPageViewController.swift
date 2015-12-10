//
//  ParseKeys.swift
//  CTCalc
//
//  Created by Cynthia Whitlatch on 11/16/15.
//  Copyright © 2015 CTC. All rights reserved.
//
import UIKit
import Parse

class MainPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    @IBAction func leftSideButtonTapped(sender: AnyObject) {
        
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
 //       appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
        
    }

    @IBAction func rightSideButtonTapped(sender: AnyObject) {
        
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
 
//        appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
    }
}
