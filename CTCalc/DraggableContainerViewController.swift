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

let kViewControllerIDs:[String] = ["MainCollection", "FirstContainerCollection", "MakerNavigation"]

class DraggableContainerViewController: UIViewController {
	
	//I tried to be nice and do this with an IBInspectable array
	//but it's not possible
	//constants it is then!
//	@IBInspectable var viewControllerIDs:[String] = ["Nothing"]
	
	var viewControllers = [UIViewController]()
	weak var activeViewController:UIViewController?
	
	private func transition(from:UIViewController, to:UIViewController, direction:(CGFloat, CGFloat))
	{
		activeViewController = to


		self.addChildViewController(to)
		to.view.frame = view.bounds
		view.addSubview(to.view)
		
		to.view.bounds.origin.x = direction.0 * view.bounds.width * -1
		to.view.bounds.origin.y = direction.1 * view.bounds.height * -1
		
		UIView.animateWithDuration(0.1, animations:
		{
			from.view.bounds.origin.x = direction.0 * self.view.bounds.width
			from.view.bounds.origin.y = direction.1 * self.view.bounds.height
		})
		{ (success) in
			from.view.removeFromSuperview()
			from.removeFromParentViewController()
			
			UIView.animateWithDuration(0.1, animations:
			{
				to.view.bounds.origin.x = 0
				to.view.bounds.origin.y = 0
			})
			{ (success) in
				to.didMoveToParentViewController(self)
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
		
		
		//set the initial view controller
		activeViewController = viewControllers[0]
		if let newValue = activeViewController
		{
			addChildViewController(newValue)
			newValue.view.frame = view.bounds
			view.addSubview(newValue.view)
			newValue.didMoveToParentViewController(self)
		}
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
	
	func segue(to:String, left:Bool)
	{
		if let vc = getControllerWithID(to)
		{
			transition(activeViewController!, to: vc, direction: (left ? -1 : 1, 0))
		}
	}
	
	func panned(sender:UIPanGestureRecognizer)
	{
		dragDelegate?.panned(sender)
	}
	
	//MARK: supported orientations
	override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
		return UIInterfaceOrientationMask.All
	}
	
	//MARK: slightly entangled helper function zone
	func removeToken(token:Token)
	{
		func removeTokenInner(token:Token, from:DraggableButtonCollectionViewController)
		{
			for (i, t) in from.buttonsLandscape.enumerate()
			{
				if t.symbol == token.symbol
				{
					from.buttonsLandscape[i] = kTokenBlank
					from.saveButtons()
					return
				}
			}
		}
		
		removeTokenInner(token, from: viewControllers[0] as! DraggableButtonCollectionViewController)
		removeTokenInner(token, from: viewControllers[1] as! DraggableButtonCollectionViewController)
	}
	
	func addToken(token:Token)->Bool
	{
		func addTokenInner(token:Token, to:DraggableButtonCollectionViewController) -> Bool
		{
			for (i, t) in to.buttonsLandscape.enumerate()
			{
				if t.symbol == " "
				{
					to.buttonsLandscape[i] = token
					to.saveButtons()
					return true
				}
			}
			return false
		}
		
		if addTokenInner(token, to: viewControllers[0] as! DraggableButtonCollectionViewController)
		{
			return true
		}
		return addTokenInner(token, to: viewControllers[1] as! DraggableButtonCollectionViewController)
	}
}