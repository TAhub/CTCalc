//
//  ButtonCollectionViewCell.swift
//  CTCalc
//
//  Created by Theodore Abshire on 11/16/15.
//  Copyright © 2015 CTC. All rights reserved.
//

import UIKit

class ButtonCollectionViewCell: UICollectionViewCell {
    
	@IBOutlet weak var label: UILabel!
	@IBOutlet weak var imageView: UIImageView!
	
	
	var token:Token?
	{
		didSet
		{
			if let token = token
			{
				imageView.image = token.image
				label.text = token.symbol
			}
		}
	}
}
