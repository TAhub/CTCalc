//
//  CalculatorCollectionViewController.swift
//  CTCalc
//
//  Created by Theodore Abshire on 11/13/15.
//  Copyright © 2015 CTC. All rights reserved.
//

import UIKit

class CalculatorCollectionViewController: DraggableButtonCollectionViewController {

	override func viewDidLoad() {
        super.viewDidLoad()

        for i in 0..<Int(kPortraitButtonsPerRow*kPortraitButtonsPerColumn)
		{
			buttonsPortrait.append(i)
		}
		for i in 0..<Int(kLandscapeButtonsPerRow*kLandscapeButtonsPerColumn)
		{
			buttonsLandscape.append(i)
		}
    }
}
