//
//  DraggableNavigationController.swift
//  CTCalc
//
//  Created by Theodore Abshire on 11/15/15.
//  Copyright © 2015 CTC. All rights reserved.
//

import UIKit

protocol DraggableNavigationControllerDelegate
{
	func panned(sender: UIPanGestureRecognizer)
}

class DraggableNavigationController: UINavigationController {

	var dragDelegate:DraggableNavigationControllerDelegate?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		let pancakes = UIPanGestureRecognizer()
		pancakes.addTarget(self, action: "panned:")
		view.addGestureRecognizer(pancakes)
    }
	
	func panned(sender:UIPanGestureRecognizer)
	{
		dragDelegate?.panned(sender)
	}
}
