//
//  DraggableButtonCollectionViewController.swift
//  CTCalc
//
//  Created by Theodore Abshire on 11/13/15.
//  Copyright © 2015 CTC. All rights reserved.
//

import UIKit


struct PickedUpCell
{
	var cellRow:Int
	var appearance:UIView
	var viewControllerFrom:DraggableButtonCollectionViewController
}

class DraggableButtonCollectionViewController: UICollectionViewController, DraggableContainerViewControllerDelegate {
	var buttonsPortrait = [Token]()
	{
		didSet
		{
			collectionView?.reloadData()
		}
	}
	var buttonsLandscape = [Token]()
	{
		didSet
		{
			collectionView?.reloadData()
		}
	}
	
	var screenNum:Int!
	@IBInspectable var rightSegue:String? = nil
	@IBInspectable var leftSegue:String? = nil
	
	func loadButtons() -> Bool
	{
		let def = NSUserDefaults.standardUserDefaults()
		
		if def.objectForKey("\(screenNum)exists") == nil
		{
			//load the default buttons
			return false
		}
		else
		{
			func loadButtons(prefix:String) -> [Token]
			{
				let symbols = def.stringArrayForKey("screen\(screenNum)\(prefix)symbols")!
				let functions = def.stringArrayForKey("screen\(screenNum)\(prefix)functions")!
				
				var tokens = [Token]()
				for i in 0..<symbols.count
				{
					let symbol = symbols[i]
					let function = functions[i]
					
					//check the default ones
					var isPreset = false
					for preset in kDefaultTokens
					{
						if preset.symbol == symbol
						{
							tokens.append(preset)
							isPreset = true
							break
						}
					}
					if !isPreset
					{
						//it must be custom
						print("custom token \"\(symbol)\"")
						tokens.append(Token(symbol: symbol, order: kOrderFunc, effect0: nil, effect1: nil, effect2: nil, functionReplace: function))
					}
				}
				return tokens
			}
			
			buttonsPortrait = loadButtons("portrait")
			buttonsLandscape = loadButtons("landscape")
		}
		return true
	}
	
	func saveButtons()
	{
		let def = NSUserDefaults.standardUserDefaults()
		
		def.setObject([], forKey: "\(screenNum)exists")
		
		func saveButtons(prefix:String, tokens:[Token])
		{
			def.setObject(tokens.map() { $0.symbol }, forKey: "screen\(screenNum)\(prefix)symbols")
			def.setObject(tokens.map() { $0.functionReplace ?? "" }, forKey: "screen\(screenNum)\(prefix)functions")
		}
		
		saveButtons("portrait", tokens: buttonsPortrait)
		saveButtons("landscape", tokens: buttonsLandscape)
	}
	
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
			if !pickedUp.appearance.isDescendantOfView(view)
			{
				view.addSubview(pickedUp.appearance)
			}
		}
		
		(self.parentViewController as? DraggableContainerViewController)?.dragDelegate = self
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		//the screen doesn't know about it's layout before here
		generateLayout()
	}
	
	var readOnlyButtons:[Token]
	{
		return (landscape ? buttonsLandscape : buttonsPortrait)
	}
	
	//MARK: drag and drop stuff
	private var pickedUp:PickedUpCell?
	{
		didSet
		{
			//remove it from the superview, if that superview was you
			if let old = oldValue
			{
				if old.appearance.isDescendantOfView(view)
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
	
	private var psuedoSegueMode:Bool = false
	
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
				else if let path = collectionView?.indexPathForItemAtPoint(point), let cell = collectionView?.cellForItemAtIndexPath(NSIndexPath(forItem: path.row, inSection: path.section))
				{
					//pick something up
					let startX = collectionView!.contentOffset.x + cell.frame.origin.x
					let startY = collectionView!.contentOffset.y + cell.frame.origin.y
					
					//load the cell from a nib
					let loadedNib = NSBundle.mainBundle().loadNibNamed("CalculatorButton", owner: self, options: nil)[0] as! ButtonCollectionViewCell
					loadedNib.frame = CGRect(x: startX, y: startY, width: cell.bounds.width, height: cell.bounds.height)
					loadedNib.label.text = readOnlyButtons[path.row].symbol
					
					view.addSubview(loadedNib)
					
					pickedUp = PickedUpCell(cellRow: path.row, appearance: loadedNib, viewControllerFrom: self)
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
					
					//save the new layout
					saveButtons()
					if pickedUp.viewControllerFrom != self
					{
						pickedUp.viewControllerFrom.saveButtons()
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
			if !psuedoSegueMode
			{
				if drag.x < 0 && point.x < 40
				{
					psuedoSegueMode = true
					psuedoSegue(leftSegue)
				}
				else if drag.x > 0 && point.x > collectionView!.bounds.width - 40
				{
					psuedoSegueMode = true
					psuedoSegue(rightSegue)
				}
			}
		}
		else
		{
			psuedoSegueMode = false
		}
	}
	
	private func psuedoSegue(id:String?)
	{
		if let id = id, let dcvc = parentViewController as? DraggableContainerViewController
		{
			if let dest = dcvc.getControllerWithID(id) as? DraggableButtonCollectionViewController
			{
				dest.psuedoSegueMode = psuedoSegueMode
				transferCell(dest)
			}
			else
			{
				editMode = false
				pickedUp = nil
			}
			dcvc.segue(id)
		}
	}
	
	var transitioning:Bool = false
	override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
		transitioning = true
		collectionView?.reloadData()
		coordinator.animateAlongsideTransition(nil)
		{ (success) in
			self.generateLayout()
		
			//drop whatever you have picked up
			//because we don't want to carry something from landscape to portrait
			self.pickedUp = nil
			
			self.transitioning = false
		}
	}
	
	private var landscape:Bool
	{
		return UIApplication.sharedApplication().statusBarOrientation.isLandscape
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
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
		if transitioning
		{
			return 0
		}
        return readOnlyButtons.count
	}
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
	{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("buttonCell", forIndexPath: indexPath) as! ButtonCollectionViewCell
		cell.label.text = readOnlyButtons[indexPath.row].symbol
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
