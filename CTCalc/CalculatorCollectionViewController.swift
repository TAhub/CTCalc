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

        for _ in 0..<10
		{
			switch arc4random_uniform(4)
			{
			case 0: buttons.append(UIColor.redColor())
			case 1: buttons.append(UIColor.blueColor())
			case 2: buttons.append(UIColor.greenColor())
			default: buttons.append(UIColor.yellowColor())
			}
		}
    }

}
