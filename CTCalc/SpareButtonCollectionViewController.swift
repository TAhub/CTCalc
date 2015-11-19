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
}