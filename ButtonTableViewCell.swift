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
        return "cell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
