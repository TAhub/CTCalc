//
//  DraggableButtonCollectionViewController.swift
//  CTCalc
//
//  Created by Theodore Abshire on 11/13/15.
//  Copyright © 2015 CTC. All rights reserved.
//

import UIKit

private let reuseIdentifier = "buttonCell"

class DraggableButtonCollectionViewController: UICollectionViewController {
	var buttons = [UIColor]()
	{
		didSet
		{
			collectionView?.reloadData()
		}
	}
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		let recognizer = UILongPressGestureRecognizer()
		recognizer.addTarget(self, action: "toggleEditMode:")
		view.addGestureRecognizer(recognizer)
		
		let pancakes = UIPanGestureRecognizer()
		pancakes.addTarget(self, action: "panned:")
		view.addGestureRecognizer(pancakes)
	}
	
	//MARK: drag and drop stuff
	private var tappedCellAppearance:UIView?
	private var tappedCell:Int?
	{
		didSet
		{
			if let tappedCell = tappedCell, let cell = collectionView?.cellForItemAtIndexPath(NSIndexPath(forItem: tappedCell, inSection: 0))
			{
				let startX = collectionView!.contentOffset.x + cell.frame.origin.x
				let startY = collectionView!.contentOffset.y + cell.frame.origin.y
				tappedCellAppearance = UIView(frame: CGRect(x: startX, y: startY, width: cell.bounds.width, height: cell.bounds.height))
				tappedCellAppearance!.backgroundColor = cell.backgroundColor
				view.addSubview(tappedCellAppearance!)
			}
			else
			{
				tappedCellAppearance?.removeFromSuperview()
				tappedCellAppearance = nil
			}
			collectionView?.reloadData()
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
				if let path = collectionView?.indexPathForItemAtPoint(point)
				{
					tappedCell = path.row
				}
			case UIGestureRecognizerState.Changed:
				if let tappedCellAppearance = tappedCellAppearance
				{
					tappedCellAppearance.frame.origin.x += drag.x
					tappedCellAppearance.frame.origin.y += drag.y
					tappedCellAppearance.layoutIfNeeded()
				}
			case UIGestureRecognizerState.Ended:
				if let path = collectionView?.indexPathForItemAtPoint(point), let tappedCell = tappedCell
				{
					let old = buttons[path.row]
					buttons[path.row] = buttons[tappedCell]
					buttons[tappedCell] = old
				}
				tappedCell = nil
			default: break
			}
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
		cell.hidden = tappedCell != nil && tappedCell! == indexPath.row
		return cell
	}
	
}
