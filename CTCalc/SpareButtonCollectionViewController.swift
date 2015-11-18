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
			buttonsPortrait = [Token]()
			buttonsLandscape = [Token]()
			
			for _ in 0..<Int(kPortraitButtonsPerColumn*kPortraitButtonsPerRow)
			{
				buttonsPortrait.append(kTokenBlank)
			}
			
			for _ in 0..<Int(kLandscapeButtonsPerRow*kLandscapeButtonsPerColumn)
			{
				buttonsLandscape.append(kTokenBlank)
			}
			
			saveButtons()
		}
	}
}