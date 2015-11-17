//
//  CalculatorCollectionViewController.swift
//  CTCalc
//
//  Created by Theodore Abshire on 11/13/15.
//  Copyright © 2015 CTC. All rights reserved.
//

import UIKit

class CalculatorCollectionViewController: DraggableButtonCollectionViewController {

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
    }
	
	//press buttons
	override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		if !editing
		{
			calculator.applyToken(readOnlyButtons[indexPath.row])
			print("\(calculator.tokenString) = \(calculator.result)")
		}
	}
}
