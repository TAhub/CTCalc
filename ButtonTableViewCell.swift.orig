//
//  ButtonTableViewCell.swift
//  CTCalc
//
//  Created by Cynthia Whitlatch on 11/16/15.
//  Copyright © 2015 CTC. All rights reserved.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var function: UILabel!
    @IBOutlet weak var symbol: UILabel!
    @IBOutlet weak var buttonImage: UIImageView!
	
	class func identifier() -> String {
        return "ButtonTableViewCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

	var reloadClosure:(()->())!
	var dcvc:DraggableContainerViewController!
	var token:Token?
	{
		didSet
		{
			reloadNames()
		}
	}

	private func reloadNames()
	{
		if let token = token
		{
			function.text = token.functionReplace ?? ""
			symbol.text = token.symbol
			buttonImage.image = kImages[token.imageNumber]
			
			addButton.hidden = dcvc.hasToken(token, checkRandom: false)
			removeButton.hidden = !dcvc.hasToken(token, checkRandom: true)
		}
	}

	@IBOutlet weak var addButton: UIButton!
	@IBOutlet weak var removeButton: UIButton!
	
	
	@IBAction func addAction()
	{
		dcvc.addToken(token!)
		reloadClosure()
	}
	
	@IBAction func removeAction()
	{
		dcvc.removeToken(token!)
		reloadClosure()
	}
	
}
