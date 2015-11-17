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
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		screenNum = 1
		
		if !loadButtons()
		{
			for _ in 0..<Int(kPortraitButtonsPerColumn*kPortraitButtonsPerRow)
			{
				buttonsPortrait.append(kTokenPlus)
			}
			
			for _ in 0..<Int(kLandscapeButtonsPerRow*kLandscapeButtonsPerColumn)
			{
				buttonsLandscape.append(kTokenPlus)
			}
		}
	}
}