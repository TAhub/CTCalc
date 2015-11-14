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

        for _ in 0..<20
		{
			switch arc4random_uniform(8)
			{
			case 0: buttons.append(UIColor.redColor())
			case 1: buttons.append(UIColor.blueColor())
			case 2: buttons.append(UIColor.greenColor())
			case 3: buttons.append(UIColor.brownColor())
			case 4: buttons.append(UIColor.whiteColor())
			case 5: buttons.append(UIColor.purpleColor())
			case 6: buttons.append(UIColor.orangeColor())
			case 7: buttons.append(UIColor.lightGrayColor())
			default: buttons.append(UIColor.yellowColor())
			}
		}
    }
}
