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
	func swiped(sender: UISwipeGestureRecognizer)
}

let kViewControllerIDs:[String] = ["MainCollection", "FirstContainerCollection", "MakerNavigation"]

class DraggableContainerViewController: UIViewController, UIGestureRecognizerDelegate {
	
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
		pancakes.delegate = self
		view.addGestureRecognizer(pancakes)
		
		let swipecakesL = UISwipeGestureRecognizer()
		swipecakesL.addTarget(self, action: "swiped:")
		swipecakesL.delegate = self
		swipecakesL.direction = UISwipeGestureRecognizerDirection.Left
		view.addGestureRecognizer(swipecakesL)
		
		let swipecakesR = UISwipeGestureRecognizer()
		swipecakesR.addTarget(self, action: "swiped:")
		swipecakesR.delegate = self
		swipecakesR.direction = UISwipeGestureRecognizerDirection.Right
		view.addGestureRecognizer(swipecakesR)
		
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
	
	func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
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
			transition(activeViewController!, to: vc, direction: (left ? 1 : -1, 0))
		}
	}
	
	func panned(sender:UIPanGestureRecognizer)
	{
		dragDelegate?.panned(sender)
	}
	
	func swiped(sender:UISwipeGestureRecognizer)
	{
		dragDelegate?.swiped(sender)
	}
	
	//MARK: supported orientations
//	override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
//		return UIInterfaceOrientationMask.All
//	}
	
	//MARK: slightly entangled helper function zone
	func removeToken(token:Token)
	{
		func removeTokenInner(token:Token, from:DraggableButtonCollectionViewController)
		{
			for (i, t) in from.buttonsLandscape.enumerate()
			{
				if t.symbol == token.symbol && t.random == token.random
				{
					from.buttonsLandscape[i] = kTokenBlank
					from.saveButtons()
					return
				}
			}
		}
		
		let cpc = viewControllers[0] as! CalculatorCollectionViewController
		let spc = viewControllers[1] as! SpareButtonCollectionViewController
		spc.loadMyStuff()
		
		removeTokenInner(token, from: cpc)
		removeTokenInner(token, from: spc)
	}
	
	func hasToken(token:Token, checkRandom:Bool)->Bool
	{
		func hasToken(token:Token, to:DraggableButtonCollectionViewController) -> Bool
		{
			for t in to.buttonsLandscape
			{
				if t.symbol == token.symbol && (!checkRandom || t.random == token.random)
				{
					return true
				}
			}
			return false
		}
		
		let cpc = viewControllers[0] as! CalculatorCollectionViewController
		let spc = viewControllers[1] as! SpareButtonCollectionViewController
		spc.loadMyStuff()
		
		return hasToken(token, to: cpc) || hasToken(token, to: spc)
	}
	
	func addToken(token:Token)->Bool
	{
		if hasToken(token, checkRandom: false)
		{
			return false
		}
		
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
		
		
		let cpc = viewControllers[0] as! CalculatorCollectionViewController
		let spc = viewControllers[1] as! SpareButtonCollectionViewController
		spc.loadMyStuff()
		
		if addTokenInner(token, to: cpc)
		{
			return true
		}
		return addTokenInner(token, to: spc)
	}
}