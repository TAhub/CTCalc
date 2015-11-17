//
//  ButtonTableViewCell.swift
//  CTCalc
//
//  Created by Cynthia Whitlatch on 11/16/15.
//  Copyright © 2015 CTC. All rights reserved.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var buttonFunction: UILabel!
    @IBOutlet weak var buttonName: UILabel!
    @IBOutlet weak var buttomImage: UIView!
    
    
    class func identifier() -> String {
        return "cell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
