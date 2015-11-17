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
		
		screenNum = 1
		
		loadMyStuff()
	}
	
	private func loadMyStuff()
	{
		if !loadButtons()
		{
			for _ in 0..<Int(kPortraitButtonsPerColumn*kPortraitButtonsPerRow)
			{
				buttonsPortrait.append(kTokenBlank)
			}
			
			for _ in 0..<Int(kLandscapeButtonsPerRow*kLandscapeButtonsPerColumn)
			{
				buttonsLandscape.append(kTokenBlank)
			}
		}
	}
}