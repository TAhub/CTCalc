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
		
		screenNum = 1
		
		loadMyStuff()
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		loadMyStuff()
	}
	
	private func loadMyStuff()
	{
		if !loadButtons()
		{
            //portrait
            buttonsPortrait.append(kTokenBlank)
            buttonsPortrait.append(kTokenBlank)
            buttonsPortrait.append(kTokenBlank)
            buttonsPortrait.append(kTokenBlank)
            
            buttonsPortrait.append(kTokenBlank)
            buttonsPortrait.append(kTokenBlank)
            buttonsPortrait.append(kTokenBlank)
            buttonsPortrait.append(kTokenBlank)
            
            buttonsPortrait.append(kTokenBlank)
            buttonsPortrait.append(kTokenBlank)
            buttonsPortrait.append(kTokenBlank)
            buttonsPortrait.append(kTokenBlank)
            
            buttonsPortrait.append(kTokenBlank)
            buttonsPortrait.append(kTokenBlank)
            buttonsPortrait.append(kTokenBlank)
            buttonsPortrait.append(kTokenBlank)
            
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
            
            
		}
	}
}