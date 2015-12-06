//
//  SpareButtonCollectionViewController.swift
//  CTCalc
//
//  Created by Theodore Abshire on 11/17/15.
//  Copyright © 2015 CTC. All rights reserved.
//

import UIKit

class SpareButtonCollectionViewController: DraggableButtonCollectionViewController
{
	override func viewDidLoad() {
		super.viewDidLoad()
		
		loadMyStuff()
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		loadMyStuff()
	}
	
	func loadMyStuff()
	{
		screenNum = 1
		
		if !loadButtons()
		{
            buttonsPortrait = [Token]()
            buttonsLandscape = [Token]()
            
            //portrait
            buttonsPortrait.append(kTokenSin)
            buttonsPortrait.append(kTokenTan)
            buttonsPortrait.append(kTokenCos)
            buttonsPortrait.append(kTokenSquare)
            
            buttonsPortrait.append(kTokenSinH)
            buttonsPortrait.append(kTokenTanH)
            buttonsPortrait.append(kTokenCosH)
            buttonsPortrait.append(kTokenCube)
            
            buttonsPortrait.append(kTokenSquareRoot)
            buttonsPortrait.append(kTokenCubeRoot)
            buttonsPortrait.append(kTokenOneOver)
            buttonsPortrait.append(kTokenEuler)
            
            buttonsPortrait.append(kTokenSParen)
            buttonsPortrait.append(kTokenEParen)
            buttonsPortrait.append(kTokenComma)
            buttonsPortrait.append(kTokenLog)
            
            buttonsPortrait.append(kTokenHelp)
            buttonsPortrait.append(kTokenRandom)
            buttonsPortrait.append(kTokenRound)
            buttonsPortrait.append(kTokenNaturalLog)

            buttonsPortrait.append(kTokenBlank)
			buttonsPortrait.append(kTokenBlank)
			buttonsPortrait.append(kTokenBlank)
			buttonsPortrait.append(kTokenBlank)
			
            //landscape
            
            buttonsLandscape.append(kTokenA)
            buttonsLandscape.append(kTokenB)
            buttonsLandscape.append(kTokenC)
            buttonsLandscape.append(kTokenD)
            
            buttonsLandscape.append(kTokenE)
            buttonsLandscape.append(kTokenBlank)
            buttonsLandscape.append(kTokenBlank)
            buttonsLandscape.append(kTokenBlank)
            
            buttonsLandscape.append(kTokenBlank)
            buttonsLandscape.append(kTokenBlank)
            buttonsLandscape.append(kTokenBlank)
            buttonsLandscape.append(kTokenBlank)
            
            buttonsLandscape.append(kTokenBlank)
            buttonsLandscape.append(kTokenBlank)
            buttonsLandscape.append(kTokenBlank)
            buttonsLandscape.append(kTokenBlank)
            
            buttonsLandscape.append(kTokenBlank)
            buttonsLandscape.append(kTokenBlank)
            buttonsLandscape.append(kTokenBlank)
            buttonsLandscape.append(kTokenBlank)
            
            buttonsLandscape.append(kTokenBlank)
            buttonsLandscape.append(kTokenBlank)
            buttonsLandscape.append(kTokenBlank)
            buttonsLandscape.append(kTokenBlank)
            
            buttonsLandscape.append(kTokenBlank)
            buttonsLandscape.append(kTokenBlank)
            buttonsLandscape.append(kTokenBlank)
            buttonsLandscape.append(kTokenBlank)
            
            buttonsLandscape.append(kTokenBlank)
            buttonsLandscape.append(kTokenBlank)
            buttonsLandscape.append(kTokenBlank)
            buttonsLandscape.append(kTokenBlank)
            
            buttonsLandscape.append(kTokenBlank)
            buttonsLandscape.append(kTokenBlank)
            buttonsLandscape.append(kTokenBlank)
            buttonsLandscape.append(kTokenBlank)
            
            buttonsLandscape.append(kTokenBlank)
            buttonsLandscape.append(kTokenBlank)
            buttonsLandscape.append(kTokenBlank)
            buttonsLandscape.append(kTokenBlank)
            
            buttonsLandscape.append(kTokenBlank)
            buttonsLandscape.append(kTokenBlank)
            buttonsLandscape.append(kTokenBlank)
            buttonsLandscape.append(kTokenBlank)
            
            buttonsLandscape.append(kTokenBlank)
            buttonsLandscape.append(kTokenBlank)
            buttonsLandscape.append(kTokenBlank)
            buttonsLandscape.append(kTokenBlank)

            
            
            saveButtons()
		}
	}
	
	//MARK: press calculator buttons
	private var temporaryScreen:Display?
	
	override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		if !editing && !specialButtonPress(readOnlyButtons[indexPath.row])
		{
			let dgvc = parentViewController as! DraggableContainerViewController
			let ccvc = dgvc.viewControllers[0] as! CalculatorCollectionViewController
			ccvc.calculator.applyToken(readOnlyButtons[indexPath.row])
			ccvc.collectionView?.reloadData()
			
			//make a screen to temporarily show the result
			if temporaryScreen != nil
			{
				temporaryScreen!.layer.removeAllAnimations()
			}
			else
			{
				let loadedNib = NSBundle.mainBundle().loadNibNamed("Display", owner: self, options: nil)[0] as! Display
				temporaryScreen = loadedNib
				loadedNib.translatesAutoresizingMaskIntoConstraints = false;
			}
			
			//clear constraints
			temporaryScreen!.removeConstraints(temporaryScreen!.constraints)
			temporaryScreen!.removeFromSuperview()
			view.addSubview(temporaryScreen!)
			
			//set constraints for the temporary view
			let cell = self.collectionView!.cellForItemAtIndexPath(indexPath)!
			let cH = Int(floor(cell.frame.height))
			let cD = ["display" : temporaryScreen!]
			view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-0-[display]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: cD))
			view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[display(==\(cH))]", options: NSLayoutFormatOptions(), metrics: nil, views: cD))
			
			//should it be on the bottom or top?
			if cell.frame.origin.y == 0
			{
				view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[display]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: cD))
			}
			else
			{
				view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[display]", options: NSLayoutFormatOptions(), metrics: nil, views: cD))
			}
			
			
			//make the screen fade
			temporaryScreen!.alpha = 1
			UIView.animateWithDuration(1.0, delay: 0.5, options: UIViewAnimationOptions.CurveEaseIn, animations:
			{
				self.temporaryScreen!.alpha = 0
			}, completion: nil)
			
			//make the screen actually show the result
			temporaryScreen!.entryLabel.text = ccvc.calculator.tokenString
			temporaryScreen!.resultLabel.text = ccvc.calculator.result
			
		}
	}
}