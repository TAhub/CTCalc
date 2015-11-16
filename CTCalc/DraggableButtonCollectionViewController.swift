//
//  DraggableButtonCollectionViewController.swift
//  CTCalc
//
//  Created by Theodore Abshire on 11/13/15.
//  Copyright © 2015 CTC. All rights reserved.
//

import UIKit

private let reuseIdentifier = "buttonCell"

struct PickedUpCell
{
	var cellRow:Int
	var appearance:UIView
	var viewControllerFrom:DraggableButtonCollectionViewController
}

class DraggableButtonCollectionViewController: UICollectionViewController, DraggableContainerViewControllerDelegate {
	var buttonsPortrait = [Int]()
	{
		didSet
		{
			collectionView?.reloadData()
		}
	}
	var buttonsLandscape = [Int]()
	{
		didSet
		{
			collectionView?.reloadData()
		}
	}
	
	@IBInspectable var rightSegue:String? = nil
	@IBInspectable var leftSegue:String? = nil
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		let recognizer = UILongPressGestureRecognizer()
		recognizer.addTarget(self, action: "toggleEditMode:")
		view.addGestureRecognizer(recognizer)
		
		let nib = UINib(nibName: "CalculatorButton", bundle: nil)
		collectionView?.registerNib(nib, forCellWithReuseIdentifier: "buttonCell")
	}
	
	override func viewWillAppear(animated: Bool)
	{
		super.viewWillAppear(animated)
		
		if let pickedUp = pickedUp
		{
			if !pickedUp.appearance.isDescendantOfView(collectionView!)
			{
				collectionView?.addSubview(pickedUp.appearance)
			}
		}
		
		(self.parentViewController as? DraggableContainerViewController)?.dragDelegate = self
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		//the screen doesn't know about it's layout before here
		generateLayout()
	}
	
	//MARK: drag and drop stuff
	private var pickedUp:PickedUpCell?
	{
		didSet
		{
			//remove it from the superview, if that superview was you
			if let old = oldValue
			{
				if old.appearance.superview == view
				{
					old.appearance.removeFromSuperview()
				}
			}
			
			collectionView?.reloadData()
		}
	}
	
	func transferCell(to:DraggableButtonCollectionViewController)
	{
		to.editMode = editMode
		if let pickedUp = pickedUp
		{
			//give them your pickedUp
			to.pickedUp = pickedUp
			//you can't add it's appearance yet, so do that later
			
			//remove it from yourself
			self.pickedUp = nil
		}
	}
	
	private var editMode:Bool = false
	{
		didSet
		{
			collectionView?.reloadData()
		}
	}
	
	func toggleEditMode(sender: UILongPressGestureRecognizer)
	{
		if sender.state == UIGestureRecognizerState.Began
		{
			editMode = !editMode
			if !editMode
			{
				pickedUp = nil
			}
		}
	}
	
	func panned(sender: UIPanGestureRecognizer)
	{
		let point = sender.locationInView(view)
		let drag = sender.translationInView(view)
		sender.setTranslation(CGPointZero, inView: view)
		
		if editMode
		{
			switch sender.state
			{
			case UIGestureRecognizerState.Began:
				if let pickedUp = pickedUp
				{
					//you've carried a view from elsewhere
					pickedUp.appearance.frame.origin.x = point.x
					pickedUp.appearance.frame.origin.y = point.y
				}
				else if let path = collectionView?.indexPathForItemAtPoint(point), let cell = collectionView?.cellForItemAtIndexPath(NSIndexPath(forItem: path.row, inSection: 0))
				{
					//pick something up
					let startX = collectionView!.contentOffset.x + cell.frame.origin.x
					let startY = collectionView!.contentOffset.y + cell.frame.origin.y
					let pickedUpCellView = UIView(frame: CGRect(x: startX, y: startY, width: cell.bounds.width, height: cell.bounds.height))
					pickedUpCellView.backgroundColor = cell.backgroundColor
					view.addSubview(pickedUpCellView)
					
					pickedUp = PickedUpCell(cellRow: path.row, appearance: pickedUpCellView, viewControllerFrom: self)
				}
			case UIGestureRecognizerState.Changed:
				if let pickedUp = pickedUp
				{
					//move whatever you have picked up
					pickedUp.appearance.frame.origin.x += drag.x
					pickedUp.appearance.frame.origin.y += drag.y
				}
			case UIGestureRecognizerState.Ended:
				if let path = collectionView?.indexPathForItemAtPoint(point), let pickedUp = pickedUp
				{
					if landscape
					{
						let old = buttonsLandscape[path.row]
						buttonsLandscape[path.row] = pickedUp.viewControllerFrom.buttonsLandscape[pickedUp.cellRow]
						pickedUp.viewControllerFrom.buttonsLandscape[pickedUp.cellRow] = old
					}
					else
					{
						let old = buttonsPortrait[path.row]
						buttonsPortrait[path.row] = pickedUp.viewControllerFrom.buttonsPortrait[pickedUp.cellRow]
						pickedUp.viewControllerFrom.buttonsPortrait[pickedUp.cellRow] = old
					}
				}
				
				//remove picked up
				self.pickedUp = nil
			default: break
			}
		}
		
		
		//TODO: this is temporary code to change view controller
		//there is probably a better way to do this
		//I tried a swipe recognizer, but you can't do that while dragging
		if sender.state == UIGestureRecognizerState.Changed
		{
			if drag.x < 0 && point.x < 40
			{
				if let leftSegue = leftSegue
				{
					(parentViewController as? DraggableContainerViewController)?.segue(leftSegue)
				}
			}
			else if drag.x > 0 && point.x > collectionView!.bounds.width - 40
			{
				if let rightSegue = rightSegue
				{
					(parentViewController as? DraggableContainerViewController)?.segue(rightSegue)
				}
			}
		}
	}
	
	override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
		coordinator.animateAlongsideTransition(nil)
		{ (success) in
			self.generateLayout()
		
			//drop whatever you have picked up
			//because we don't want to carry something from landscape to portrait
			self.pickedUp = nil
		}
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
	{
		if let dest = segue.destinationViewController as? DraggableButtonCollectionViewController
		{
			transferCell(dest)
		}
		else
		{
			editMode = false
			pickedUp = nil
		}
	}
	
	private func generateLayout()
	{
		collectionView?.collectionViewLayout = ButtonLayout(contentSize: view.frame.size, landscape: landscape)
		collectionView?.reloadData()
	}
	
	//MARK: collection view dataSource
	override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
	{
		return 1
	}
	
	private var landscape:Bool
	{
		return interfaceOrientation.isLandscape
	}
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
	{
		return (landscape ? buttonsLandscape : buttonsPortrait).count
	}
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
	{
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ButtonCollectionViewCell
		cell.label.text = "\((landscape ? buttonsLandscape : buttonsPortrait)[indexPath.row])"
		if editMode
		{
			cell.layer.cornerRadius = 0
		}
		else
		{
			cell.layer.cornerRadius = 10
		}
		cell.hidden = pickedUp != nil && pickedUp!.cellRow == indexPath.row && pickedUp!.viewControllerFrom === self
		return cell
	}
}
