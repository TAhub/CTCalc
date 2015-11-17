//
//  ButtonLayout.swift
//  CTCalc
//
//  Created by Theodore Abshire on 11/16/15.
//  Copyright © 2015 CTC. All rights reserved.
//

import UIKit

let kPortraitButtonsPerRow:CGFloat = 4
let kPortraitButtonsPerColumn:CGFloat = 6
let kLandscapeButtonsPerRow:CGFloat = 8
let kLandscapeButtonsPerColumn:CGFloat = 6
let kPortraitButtons = Int(kPortraitButtonsPerRow*(kPortraitButtonsPerColumn - 1))
let kLandscapeButtons = Int(kLandscapeButtonsPerRow*(kLandscapeButtonsPerColumn - 1))

class ButtonLayout: UICollectionViewFlowLayout {

	init(contentSize:CGSize, landscape:Bool)
	{
		super.init()
		
		self.minimumLineSpacing = 0
		self.minimumInteritemSpacing = 0
		let pr = (landscape ? kLandscapeButtonsPerRow : kPortraitButtonsPerRow)
		let pc = (landscape ? kLandscapeButtonsPerColumn : kPortraitButtonsPerColumn)
		self.itemSize = CGSize(width: contentSize.width / pr, height: contentSize.height / pc)
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
}
