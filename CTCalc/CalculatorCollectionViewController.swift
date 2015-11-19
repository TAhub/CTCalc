//
//  CalculatorCollectionViewController.swift
//  CTCalc
//
//  Created by Theodore Abshire on 11/13/15.
//  Copyright © 2015 CTC. All rights reserved.
//

import UIKit

class CalculatorCollectionViewController: DraggableButtonCollectionViewController, UICollectionViewDelegateFlowLayout {

	let calculator = CalculatorModel()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		screenNum = 0
        
        let displayNib = UINib(nibName: "Display", bundle: nil)
        collectionView?.registerNib(displayNib, forCellWithReuseIdentifier: "Display")
        
        collectionView?.delegate = self
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(true)
		
		if !loadButtons()
		{
			buttonsPortrait = [Token]()
			buttonsLandscape = [Token]()
			
            //portrait
			buttonsPortrait.append(kTokenBack)
			buttonsPortrait.append(kTokenClear)
			buttonsPortrait.append(kTokenExp)
			buttonsPortrait.append(kTokenInverse)
			
			buttonsPortrait.append(kTokenOne)
			buttonsPortrait.append(kTokenTwo)
			buttonsPortrait.append(kTokenThree)
			buttonsPortrait.append(kTokenPlus)
			
			buttonsPortrait.append(kTokenFour)
			buttonsPortrait.append(kTokenFive)
			buttonsPortrait.append(kTokenSix)
			buttonsPortrait.append(kTokenMinus)
			
			buttonsPortrait.append(kTokenSeven)
			buttonsPortrait.append(kTokenEight)
			buttonsPortrait.append(kTokenNine)
			buttonsPortrait.append(kTokenMult)
            
            buttonsPortrait.append(kTokenPi)
            buttonsPortrait.append(kTokenZero)
            buttonsPortrait.append(kTokenDot)
            buttonsPortrait.append(kTokenDiv)
            
            //landscape
            buttonsLandscape.append(kTokenSin)
            buttonsLandscape.append(kTokenTan)
            buttonsLandscape.append(kTokenCos)
            buttonsLandscape.append(kTokenSquare)
            
            buttonsLandscape.append(kTokenBack)
            buttonsLandscape.append(kTokenClear)
            buttonsLandscape.append(kTokenExp)
            buttonsLandscape.append(kTokenInverse)
            
            buttonsLandscape.append(kTokenSinH)
            buttonsLandscape.append(kTokenTanH)
            buttonsLandscape.append(kTokenCosH)
            buttonsLandscape.append(kTokenCube)
            
            buttonsLandscape.append(kTokenOne)
            buttonsLandscape.append(kTokenTwo)
            buttonsLandscape.append(kTokenThree)
            buttonsLandscape.append(kTokenPlus)
            
            buttonsLandscape.append(kTokenSquareRoot)
            buttonsLandscape.append(kTokenCubeRoot)
            buttonsLandscape.append(kTokenOneOver)
            buttonsLandscape.append(kTokenEuler)
            
            buttonsLandscape.append(kTokenFour)
            buttonsLandscape.append(kTokenFive)
            buttonsLandscape.append(kTokenSix)
            buttonsLandscape.append(kTokenMinus)
            
            buttonsLandscape.append(kTokenSParen)
            buttonsLandscape.append(kTokenEParen)
            buttonsLandscape.append(kTokenComma)
            buttonsLandscape.append(kTokenLog)
            
            buttonsLandscape.append(kTokenSeven)
            buttonsLandscape.append(kTokenEight)
            buttonsLandscape.append(kTokenNine)
            buttonsLandscape.append(kTokenMult)
            
            buttonsLandscape.append(kTokenHelp)
            buttonsLandscape.append(kTokenRandom)
            buttonsLandscape.append(kTokenRound)
            buttonsLandscape.append(kTokenNaturalLog)
            
            buttonsLandscape.append(kTokenPi)
            buttonsLandscape.append(kTokenZero)
            buttonsLandscape.append(kTokenDot)
            buttonsLandscape.append(kTokenDiv)
            
            saveButtons()
		}
	}
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if !NSUserDefaults.standardUserDefaults().boolForKey("shownTutorial")
        {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "shownTutorial")
            showTutorial()
        }
    }
	
	//press buttons
	override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		if !editing && indexPath.section != 0
		{
			calculator.applyToken(readOnlyButtons[indexPath.row])
            collectionView.reloadData()
            
            if readOnlyButtons[indexPath.row].symbol == "help"
            {
                showTutorial()
            }
		}
	}
    
    private func showTutorial()
    {
        let dcvc = parentViewController! as! DraggableContainerViewController
        dcvc.performSegueWithIdentifier("showTutorial", sender: self)
    }
    
    //MARK: overrides for display
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 2
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
		if transitioning
		{
			return 0
		}
		else if section == 0
		{
			return 1
		}
		else
		{
			return readOnlyButtons.count
		}
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let displayCell = collectionView.dequeueReusableCellWithReuseIdentifier("Display", forIndexPath: indexPath) as! Display
            displayCell.entryLabel.text = calculator.tokenString
            displayCell.resultLabel.text = calculator.result
            return displayCell
        } else
        {
            return super.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let defaultSize = (collectionViewLayout as! UICollectionViewFlowLayout).itemSize
        if indexPath.section == 0
        {
            return CGSize(width: view.frame.width, height: defaultSize.height)
        }
        return defaultSize
    }
}
