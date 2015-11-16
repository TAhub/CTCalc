//
//  ButtonLayout.swift
//  CTCalc
//
//  Created by Theodore Abshire on 11/16/15.
//  Copyright © 2015 CTC. All rights reserved.
//

import UIKit

let kButtonsPerRow:CGFloat = 4
let kButtonsPerColumn:CGFloat = 8

class ButtonLayout: UICollectionViewFlowLayout {

	init(contentSize:CGSize)
	{
		super.init()
		
		self.minimumLineSpacing = 0
		self.minimumInteritemSpacing = 0
		self.itemSize = CGSize(width: contentSize.width / kButtonsPerRow, height: contentSize.height / kButtonsPerColumn)
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
}
