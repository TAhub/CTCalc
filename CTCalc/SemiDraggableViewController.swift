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
	
	func panned(sender: UIPanGestureRecognizer)
	{
		let point = sender.locationInView(view)
		let drag = sender.translationInView(view)
		sender.setTranslation(CGPointZero, inView: view)
		
		//change your view controller
		if sender.state == UIGestureRecognizerState.Changed
		{
			if !psuedoSegueMode
			{
				if drag.x < 0 && point.x < kDragMargin
				{
					psuedoSegueMode = true
					psuedoSegue(leftSegue, left: true)
				}
				else if drag.x > 0 && point.x > view!.bounds.width - kDragMargin
				{
					psuedoSegueMode = true
					psuedoSegue(rightSegue, left: false)
				}
			}
		}
		else
		{
			psuedoSegueMode = false
		}
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
