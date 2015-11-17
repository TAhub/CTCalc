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

		//add the default portrait buttons
		buttonsPortrait.append(kTokenPlus)
		buttonsPortrait.append(kTokenPlus)
		buttonsPortrait.append(kTokenPlus)
		buttonsPortrait.append(kTokenPlus)
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
		buttonsPortrait.append(kTokenSParen)
		buttonsPortrait.append(kTokenZero)
		buttonsPortrait.append(kTokenEParen)
		buttonsPortrait.append(kTokenDiv)
		buttonsPortrait.append(kSample)
		buttonsPortrait.append(kTokenComma)
		
        while buttonsPortrait.count < Int(kPortraitButtonsPerRow*kPortraitButtonsPerColumn)
		{
			buttonsPortrait.append(kTokenPlus)
		}
		for _ in 0..<Int(kLandscapeButtonsPerRow*kLandscapeButtonsPerColumn)
		{
			buttonsLandscape.append(kTokenPlus)
		}
        
        let displayNib = UINib(nibName: "Display", bundle: nil)
        collectionView?.registerNib(displayNib, forCellWithReuseIdentifier: "Display")
        
        collectionView?.delegate = self
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
    {   if section == 0 {return 1} else
    {return readOnlyButtons.count}
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
