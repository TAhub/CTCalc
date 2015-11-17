//
//ButtonTableView.swift
//  CTCalc
//
//  Created by Cynthia Whitlatch on 11/16/15.
//  Copyright © 2015 CTC. All rights reserved.
//

import UIKit
import Parse

class ButtonTableView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var buttonTableView: UITableView!
    
    var buttonImages = [PFObject]() {
        didSet {
            self.buttonTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            buttonImages.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
        }
    }

    func confirmDelete(planet: String) {
        let alert = UIAlertController(title: "Delete Button", message: "Are you sure you want to permanently delete \(buttonImages)?", preferredStyle: .ActionSheet)
        
//        let DeleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: handleDeleteButton)
//        let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelDeleteButton)
//        
//        alert.addAction(DeleteAction)
//        alert.addAction(CancelAction)
        
        // Support display in iPad
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // ...

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return buttonImages.count
}
    
                /// GET THE IMAGE FROM PARSE AND LOAD IT INTO THE TABLEVIEW
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(ButtonTableViewCell.identifier(), forIndexPath: indexPath) as! ButtonTableViewCell
//    let buttonImage = self.buttonImages[indexPath.row]
//        if let imageFile = buttonImages["image"] as? PFFile {
//            imageFile.getDataInBackgroundWithBlock({ (data, error) -> Void in
//                if let data = data {
//                    let image = UIImage(data: data)
//                    cell.imageView.image = image
//                }
//            })
        return cell

        }

}






