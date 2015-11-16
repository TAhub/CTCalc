//
//  DraggableSegue.swift
//  CTCalc
//
//  Created by Theodore Abshire on 11/16/15.
//  Copyright © 2015 CTC. All rights reserved.
//

import UIKit

class DraggableSegue: UIStoryboardSegue {

	override func perform()
	{
		let container = self.sourceViewController.parentViewController as! DraggableContainerViewController
		container.activeViewController = self.destinationViewController
	}
}
