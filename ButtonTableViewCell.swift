//
//  ButtonTableViewCell.swift
//  CTCalc
//
//  Created by Cynthia Whitlatch on 11/16/15.
//  Copyright © 2015 CTC. All rights reserved.
//

import UIKit
import Parse

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
	var deleteClosure:(()->())!
	var dcvc:DraggableContainerViewController!
	var user:String!
	var token:Token?
	{
		didSet
		{
			reloadNames()
		}
	}

	private var myButton:Bool
	{
		return user != nil && PFUser.currentUser()!.objectId == user
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
			
			if myButton && removeButton.hidden
			{
				//add the delete button
				removeButton.setTitle("Delete", forState: .Normal)
				removeButton.hidden = false
			}
			else
			{
				removeButton.setTitle("Remove", forState: .Normal)
			}
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
		if myButton && !dcvc.hasToken(token!, checkRandom: true)
		{
			deleteClosure()
		}
		else
		{
			dcvc.removeToken(token!)
			reloadClosure()
		}
	}
	
}
