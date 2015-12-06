//
//  SemiDraggableViewController.swift
//  CTCalc
//
//  Created by Theodore Abshire on 11/19/15.
//  Copyright © 2015 CTC. All rights reserved.
//

import UIKit

class SemiDraggableViewController: UINavigationController, DraggableContainerViewControllerDelegate {

	@IBInspectable var rightSegue:String? = nil
	@IBInspectable var leftSegue:String? = nil
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		(self.parentViewController as! DraggableContainerViewController).dragDelegate = self
	}
	
	var psuedoSegueMode:Bool = false
	
	func swiped(sender: UISwipeGestureRecognizer)
	{
		//this is the only gesture recognizer that works, since you can't carry around buttons in this controller
		let dir = sender.direction
		psuedoSegueMode = true
		switch(dir)
		{
		case UISwipeGestureRecognizerDirection.Right:
			psuedoSegue(rightSegue, left: false)
		case UISwipeGestureRecognizerDirection.Left:
			psuedoSegue(leftSegue, left: true)
		default: break
		}
	}
	
	func panned(sender: UIPanGestureRecognizer)
	{
		//this is disabled for now
		//I'm switching over to swipe gestures
		
//		let point = sender.locationInView(view)
//		let drag = sender.translationInView(view)
//		sender.setTranslation(CGPointZero, inView: view)
//		
//		//change your view controller
//		if sender.state == UIGestureRecognizerState.Changed
//		{
//			if !psuedoSegueMode
//			{
//				if drag.x < 0 && point.x < kDragMargin
//				{
//					psuedoSegueMode = true
//					psuedoSegue(leftSegue, left: true)
//				}
//				else if drag.x > 0 && point.x > view!.bounds.width - kDragMargin
//				{
//					psuedoSegueMode = true
//					psuedoSegue(rightSegue, left: false)
//				}
//			}
//		}
//		else
//		{
//			psuedoSegueMode = false
//		}
	}
	
	private func psuedoSegue(id:String?, left: Bool)
	{
		if let id = id, let dcvc = parentViewController as? DraggableContainerViewController
		{
			if let dest = dcvc.getControllerWithID(id) as? DraggableButtonCollectionViewController
			{
				dest.psuedoSegueMode = psuedoSegueMode
			}
			dcvc.segue(id, left: left)
		}
	}
}
