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
	var buttons = [UIColor]()
	{
		didSet
		{
			collectionView?.reloadData()
		}
	}
	
	@IBInspectable var hasRightSegue:Bool = false
	@IBInspectable var hasLeftSegue:Bool = false
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		print("did load")
		
		let recognizer = UILongPressGestureRecognizer()
		recognizer.addTarget(self, action: "toggleEditMode:")
		view.addGestureRecognizer(recognizer)
		
		collectionView?.collectionViewLayout = ButtonLayout(contentSize: CGSize(width: view.frame.width, height: view.frame.height))
	}
	
	override func viewWillAppear(animated: Bool)
	{
		super.viewWillAppear(animated)
		
		print("will appear")
		
		if let pickedUp = pickedUp
		{
			if !pickedUp.appearance.isDescendantOfView(collectionView!)
			{
				collectionView?.addSubview(pickedUp.appearance)
			}
		}
		
		(self.parentViewController as? DraggableContainerViewController)?.dragDelegate = self
		
		collectionView?.reloadData()
	}
	
	//MARK: drag and drop stuff
	private var pickedUp:PickedUpCell?
	{
		didSet
		{
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
			pickedUp.appearance.removeFromSuperview()
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
					let old = buttons[path.row]
					buttons[path.row] = pickedUp.viewControllerFrom.buttons[pickedUp.cellRow]
					pickedUp.viewControllerFrom.buttons[pickedUp.cellRow] = old
				}
				
				//remove picked up
				pickedUp?.appearance.removeFromSuperview()
				self.pickedUp = nil
			default: break
			}
		}
		
		
		//TODO: this is temporary code to change view controller
		//there is probably a better way to do this
		//I tried a swipe recognizer, but you can't do that while dragging
		if sender.state == UIGestureRecognizerState.Changed
		{
			if drag.x < 0 && point.x < 40 && hasLeftSegue
			{
				performSegueWithIdentifier("swipeLeft", sender: self)
			}
			else if drag.x > 0 && point.x > collectionView!.bounds.width - 40 && hasRightSegue
			{
				performSegueWithIdentifier("swipeRight", sender: self)
			}
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
	
	//MARK: collection view dataSource
	override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
	{
		return 1
	}
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
	{
		return buttons.count
	}
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
	{
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
		cell.backgroundColor = buttons[indexPath.row]
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
