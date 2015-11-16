//
//  DraggableContainerViewController.swift
//  CTCalc
//
//  Created by Theodore Abshire on 11/16/15.
//  Copyright © 2015 CTC. All rights reserved.
//

import UIKit

protocol DraggableContainerViewControllerDelegate
{
	func panned(sender: UIPanGestureRecognizer)
}

let kViewControllerIDs:[String] = ["MainCollection", "FirstContainerCollection"]

class DraggableContainerViewController: UIViewController {
	
	//I tried to be nice and do this with an IBInspectable array
	//but it's not possible
	//constants it is then!
//	@IBInspectable var viewControllerIDs:[String] = ["Nothing"]
	
	var viewControllers = [UIViewController]()
	weak var activeViewController:UIViewController?
	{
		didSet
		{
			if let oldValue = oldValue
			{
				removeView(oldValue)
			}
			if let activeViewController = activeViewController
			{
				addView(activeViewController)
			}
		}
	}
	
	var dragDelegate:DraggableContainerViewControllerDelegate?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let pancakes = UIPanGestureRecognizer()
		pancakes.addTarget(self, action: "panned:")
		view.addGestureRecognizer(pancakes)
		
		//load the view controllers
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		for id in kViewControllerIDs
		{
			let vc = storyboard.instantiateViewControllerWithIdentifier(id)
			viewControllers.append(vc)
		}
		assert(viewControllers.count > 0)
		activeViewController = viewControllers[0]
	}
	
	func getControllerWithID(id:String) -> UIViewController?
	{
		for i in 0..<kViewControllerIDs.count
		{
			if kViewControllerIDs[i] == id
			{
				return viewControllers[i]
			}
		}
		return nil
	}
	
	func segue(to:String)
	{
		if let vc = getControllerWithID(to)
		{
			activeViewController = vc
		}
	}
	
	private func removeView(oldValue:UIViewController)
	{
		oldValue.willMoveToParentViewController(nil)
		oldValue.view.removeFromSuperview()
		oldValue.removeFromParentViewController()
	}
	
	private func addView(newValue:UIViewController)
	{
		addChildViewController(newValue)
		newValue.view.frame = view.bounds
		view.addSubview(newValue.view)
		newValue.didMoveToParentViewController(self)
	}
	
	func panned(sender:UIPanGestureRecognizer)
	{
		dragDelegate?.panned(sender)
	}
}