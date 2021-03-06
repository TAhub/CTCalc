//
//  DraggableButtonCollectionViewController.swift
//  CTCalc
//
//  Created by Theodore Abshire on 11/13/15.
//  Copyright © 2015 CTC. All rights reserved.
//

import UIKit


let kDragMargin:CGFloat = 20

struct PickedUpCell
{
	var cellRow:Int
	var appearance:UIView
	var viewControllerFrom:DraggableButtonCollectionViewController
}

class DraggableButtonCollectionViewController: UICollectionViewController, DraggableContainerViewControllerDelegate, UIGestureRecognizerDelegate {
	var buttonsPortrait = [Token]()
//	{
//		didSet
//		{
//			collectionView?.reloadData()
//		}
//	}
	var buttonsLandscape = [Token]()
//	{
//		didSet
//		{
//			collectionView?.reloadData()
//		}
//	}

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
			func loadButtonsInner(prefix:String) -> [Token]
			{
				let symbols = def.stringArrayForKey("screen\(screenNum)\(prefix)symbols")!
				let functions = def.stringArrayForKey("screen\(screenNum)\(prefix)functions")!
				let imageNumbers = def.stringArrayForKey("screen\(screenNum)\(prefix)images")!
				let randoms = def.stringArrayForKey("screen\(screenNum)\(prefix)randoms")!
				
				var tokens = [Token]()
				for i in 0..<symbols.count
				{
					let symbol = symbols[i]
					let function = functions[i]
					let imageNumber = Int(imageNumbers[i])!
					let random = Int(randoms[i])!
					
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
						var tok = Token(symbol: symbol, order: kOrderFunc, imageNumber: imageNumber, effect0: nil, effect1: nil, effect2: nil, functionReplace: function)
						tok.random = random
						tokens.append(tok)
					}
				}
				return tokens
			}
			
			buttonsPortrait = loadButtonsInner("portrait")
			buttonsLandscape = loadButtonsInner("landscape")
			
			return true
		}
	}
	
	func saveButtons()
	{
		let def = NSUserDefaults.standardUserDefaults()
		
		def.setObject([], forKey: "\(screenNum)exists")
		
		func saveButtonsInner(prefix:String, tokens:[Token])
		{
			def.setObject(tokens.map() { $0.symbol }, forKey: "screen\(screenNum)\(prefix)symbols")
			def.setObject(tokens.map() { $0.functionReplace ?? "" }, forKey: "screen\(screenNum)\(prefix)functions")
			def.setObject(tokens.map() { "\($0.imageNumber)" }, forKey: "screen\(screenNum)\(prefix)images")
			def.setObject(tokens.map() { "\($0.random)" }, forKey : "screen\(screenNum)\(prefix)randoms")
		}
		
		saveButtonsInner("portrait", tokens: buttonsPortrait)
		saveButtonsInner("landscape", tokens: buttonsLandscape)
	}
	
	func resetButtons()
	{
		//clear NSUserDefaults
		let def = NSUserDefaults.standardUserDefaults()
		def.removeObjectForKey("0exists");
		def.removeObjectForKey("1exists");
		
		//force both controllers to reload
		let dvc = self.parentViewController as! DraggableContainerViewController
		let calc = dvc.viewControllers[0] as! CalculatorCollectionViewController
		let spare = dvc.viewControllers[1] as! SpareButtonCollectionViewController
		calc.editMode = false
		spare.editMode = false
		calc.loadMyStuff()
		spare.loadMyStuff()
		
		collectionView?.reloadData()
	}
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		let recognizer = UILongPressGestureRecognizer()
		recognizer.delegate = self
		recognizer.addTarget(self, action: "toggleEditMode:")
		view.addGestureRecognizer(recognizer)
		
		let nib = UINib(nibName: "CalculatorButton", bundle: nil)
		collectionView?.registerNib(nib, forCellWithReuseIdentifier: "buttonCell")
	}
	
	func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
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
		
		collectionView?.backgroundColor = UIColor.whiteColor()
		
		(self.parentViewController as! DraggableContainerViewController).dragDelegate = self
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
		editMode = false
		if let pickedUp = pickedUp
		{
			//give them your pickedUp
			to.pickedUp = pickedUp
			//you can't add it's appearance yet, so do that later
			
			//remove it from yourself
			self.pickedUp = nil
		}
	}
	
	var psuedoSegueMode:Bool = false
	
	private var editMode:Bool = false
	
	func toggleEditMode(sender: UILongPressGestureRecognizer)
	{
		if sender.state == UIGestureRecognizerState.Began
		{
			editMode = !editMode
			if !editMode
			{
				pickedUp = nil
			}
			collectionView?.reloadData()
			collectionView?.layoutIfNeeded()
		}
	}
	
	func swiped(sender: UISwipeGestureRecognizer)
	{
		//this changes view controller, but only while NOT carrying something
		if self.pickedUp == nil
		{
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
					if path.row == 0 && collectionView?.numberOfSections() == 2
					{
						//don't pick up the display
						return
					}
					
					//pick something up
					let startX = collectionView!.contentOffset.x + cell.frame.origin.x
					let startY = collectionView!.contentOffset.y + cell.frame.origin.y
					
					//load the container edges
					let containerMargin:CGFloat = 6
					let containerView = UIView(frame: CGRect(x: startX - containerMargin, y: startY - containerMargin, width: cell.bounds.width + 2 * containerMargin, height: cell.bounds.height + 2 * containerMargin))
					containerView.layer.cornerRadius = 10
					containerView.backgroundColor = UIColor.whiteColor()
					
					//load the cell from a nib
					let loadedNib = NSBundle.mainBundle().loadNibNamed("CalculatorButton", owner: self, options: nil)[0] as! ButtonCollectionViewCell
					loadedNib.frame = CGRect(x: containerMargin, y: containerMargin, width: cell.bounds.width, height: cell.bounds.height)
					loadedNib.token = readOnlyButtons[path.row]
					containerView.addSubview(loadedNib)
					
					view.addSubview(containerView)
					
					pickedUp = PickedUpCell(cellRow: path.row, appearance: containerView, viewControllerFrom: self)
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
		
		
		//this moves to other screens, but only while carrying stuff
		if pickedUp != nil
		{
			if sender.state == UIGestureRecognizerState.Changed
			{
				if !psuedoSegueMode
				{
					if drag.x < 0 && point.x < kDragMargin
					{
						psuedoSegueMode = true
						psuedoSegue(leftSegue, left: true)
					}
					else if drag.x > 0 && point.x > collectionView!.bounds.width - kDragMargin
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
	}
	
	private func psuedoSegue(id:String?, left: Bool)
	{
		if let id = id, let dcvc = parentViewController as? DraggableContainerViewController
		{
			if let dest = dcvc.getControllerWithID(id) as? DraggableButtonCollectionViewController
			{
				dest.psuedoSegueMode = psuedoSegueMode
				transferCell(dest)
			}
			else if let dest = dcvc.getControllerWithID(id) as? SemiDraggableViewController
			{
				dest.psuedoSegueMode = psuedoSegueMode
				editMode = false
				pickedUp = nil
			}
			dcvc.segue(id, left: left)
		}
	}
	
	var transitioning:Bool = false
	override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
		transitioning = true
		collectionView?.reloadData()
		view.alpha = 1
		coordinator.animateAlongsideTransition(
		{ (coordinator) in
			//animation
			self.view.alpha = 0
		})
		{ (success) in
			self.generateLayout()
		
			//drop whatever you have picked up
			//because we don't want to carry something from landscape to portrait
			self.pickedUp = nil
			
			self.transitioning = false
			
			UIView.animateWithDuration(0.1, animations: { self.view.alpha = 1 })
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
	
	//press buttons
	internal func specialButtonPress(token:Token)->Bool
	{
		if token.symbol == "help"
		{
			showTutorial()
			return true
		}
		else if token.symbol == "reset"
		{
			resetButtons()
			return true
		}
		else if token.symbol == "new"
		{
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let controller = storyboard.instantiateViewControllerWithIdentifier("makeButton") as! ButtonMakerViewController
			
			//get a screenshot
			UIGraphicsBeginImageContext(view.frame.size)
			view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: false)
			let shot = UIImageView(image: UIGraphicsGetImageFromCurrentImageContext())
			UIGraphicsEndImageContext()
			
			let blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
			let vEfV = UIVisualEffectView(effect: blur)
			vEfV.frame = self.view.frame;
			view.addSubview(vEfV);
			
			let dvc = self.parentViewController as! DraggableContainerViewController
			let calc = dvc.viewControllers[0] as! CalculatorCollectionViewController
			controller.function = calc.calculator.functionString
			controller.dcvc = dvc
			
			controller.view.backgroundColor = UIColor.clearColor()
			self.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
				
			self.presentViewController(controller, animated: true)
			{
				vEfV.removeFromSuperview()
				controller.view.insertSubview(vEfV, atIndex: 0)
				controller.view.insertSubview(shot, atIndex: 0)
			}
			controller.doneCompletion =
			{
				vEfV.removeFromSuperview()
				shot.removeFromSuperview()
			}
			
			return true
		}
		return false
	}
	
	private func showTutorial()
	{
		let dcvc = parentViewController! as! DraggableContainerViewController
		dcvc.performSegueWithIdentifier("showTutorial", sender: self)
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
	
	private func shakePart(view:UIView, shakeRemoveClosure: () -> ())
	{
		let xMult = (CGFloat(arc4random_uniform(100)) - 50) / 50
		let yMult = (CGFloat(arc4random_uniform(100)) - 50) / 50
		let shakeXMag = 2 * xMult
		let shakeYMag = 2 * yMult
		let shakeInter = 0.12 * Double(arc4random_uniform(100) + 50) / 100
		
		UIView.animateWithDuration(shakeInter, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations:
		{
			view.frame.origin.x += shakeXMag
			view.frame.origin.y += shakeYMag
		})
		{ (success) in
			UIView.animateWithDuration(shakeInter, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations:
			{
				view.frame.origin.x -= shakeXMag
				view.frame.origin.y -= shakeYMag
			})
			{ (success) in
				if self.editMode
				{
					self.shakePart(view, shakeRemoveClosure: shakeRemoveClosure)
				}
				else
				{
					shakeRemoveClosure()
				}
			}
		}
	}
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
	{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("buttonCell", forIndexPath: indexPath) as! ButtonCollectionViewCell
		
//		print("screen: \(screenNum), landscape: \(landscape), size: \(cell.frame.size), row: \(indexPath.row)     landscape size: \(buttonsLandscape.count), portrait size: \(buttonsPortrait.count)")
		
		cell.token = readOnlyButtons[indexPath.row]
		
		//cancel the cell's shake
		if editMode && !readOnlyButtons[indexPath.row].shaking
		{
			if landscape
			{
				buttonsLandscape[indexPath.row].shaking = true
				shakePart(cell)
				{
					self.buttonsLandscape[indexPath.row].shaking = false
				}
			}
			else
			{
				buttonsPortrait[indexPath.row].shaking = true
				shakePart(cell)
				{
					self.buttonsPortrait[indexPath.row].shaking = false
				}
			}
		}
		
//		cell.layer.cornerRadius = 10
		cell.hidden = pickedUp != nil && pickedUp!.cellRow == indexPath.row && pickedUp!.viewControllerFrom === self
		return cell
    }
}
