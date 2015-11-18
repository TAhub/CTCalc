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
            
                //filler
            buttonsLandscape.append(kTokenSquareRoot)
            buttonsLandscape.append(kTokenCubeRoot)
            
            buttonsLandscape.append(kTokenBlank)
            buttonsLandscape.append(kTokenCube)
                //filler
            
            buttonsLandscape.append(kTokenOne)
            buttonsLandscape.append(kTokenTwo)
            buttonsLandscape.append(kTokenThree)
            buttonsLandscape.append(kTokenPlus)
            
                //filler
            buttonsLandscape.append(kTokenSParen)
            buttonsLandscape.append(kTokenEParen)
            buttonsLandscape.append(kTokenComma)
            buttonsLandscape.append(kTokenEuler)
                //filler
            
            buttonsLandscape.append(kTokenFour)
            buttonsLandscape.append(kTokenFive)
            buttonsLandscape.append(kTokenSix)
            buttonsLandscape.append(kTokenMinus)
            
                //filler
            buttonsLandscape.append(kTokenBlank)
            buttonsLandscape.append(kTokenBlank)
            buttonsLandscape.append(kTokenBlank)
            buttonsLandscape.append(kTokenLog)
                //filler
            
            buttonsLandscape.append(kTokenSeven)
            buttonsLandscape.append(kTokenEight)
            buttonsLandscape.append(kTokenNine)
            buttonsLandscape.append(kTokenMult)
            
                //filler
            buttonsLandscape.append(kTokenBlank)
            buttonsLandscape.append(kTokenBlank)
            buttonsLandscape.append(kTokenBlank)
            buttonsLandscape.append(kTokenNaturalLog)
                //filler
            
            buttonsLandscape.append(kTokenPi)
            buttonsLandscape.append(kTokenZero)
            buttonsLandscape.append(kTokenDot)
            buttonsLandscape.append(kTokenDiv)
            
            saveButtons()
		}
	}
	
	//press buttons
	override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		if !editing && indexPath.section != 0
		{
			calculator.applyToken(readOnlyButtons[indexPath.row])
            collectionView.reloadData()
		}
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
