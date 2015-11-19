//
//ButtonTableView.swift
//  CTCalc
//
//  Created by Cynthia Whitlatch on 11/16/15.
//  Copyright © 2015 CTC. All rights reserved.
//

import UIKit
import Parse

class ButtonTableView: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var buttonTableView: UITableView!
    
    private var token:Token?

    var dataArray = [PFObject]()
    var filteredArray = [PFObject]()
    var searchController = UISearchController()
    var shouldShowSearchResults = false
    var buttonImages = [PFObject]() {
        didSet {
            self.buttonTableView.reloadData()
            self.searchBar.resignFirstResponder()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buttonTableView.dataSource = self
        self.buttonTableView.delegate = self
        
        self.searchBar.showsCancelButton = true
        self.searchBar.delegate = self
        
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "setButtonTableViewEditing:")
    }
    
    func setButtonTableViewEditing(editing: Bool) {
        
        self.buttonTableView.editing = !self.buttonTableView.editing
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.getParseData()
    }
    
    func getParseData(searchTerm: String? = nil) {
        let query = PFQuery(className: "ButtomImages")
        query.selectKeys(["imageNumber", "symbol", "function"])
        
        if let searchTerm = searchTerm {
            query.whereKey("function", containsString: searchTerm.lowercaseString)
        }
        
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            guard let objects = objects else {return}
            self.buttonImages = objects
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:   TABLEVIEW
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
        
    }
    
//    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .Delete {
//            
//        let myAlert = UIAlertController(title: "Delete", message: "Are you sure you want to permanently delete this button?", preferredStyle: UIAlertControllerStyle.Alert)
//            
//            let okAction = UIAlertAction(title: "OK", style: .Default, handler: { (UIAlertAction) -> Void in
////                self.buttonImages.removeAtIndex(indexPath.row)
////                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//                
//            })
//            
//            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
//            
//        myAlert.addAction(okAction)
//        myAlert.addAction(cancelAction)
//            
//        self.presentViewController(myAlert, animated: true, completion: nil)
//       
//        }
// 
//        func deleteButton(completion: (success: Bool) -> ()) {
//            
//            if let token = token
//            {
//                let dcvc = navigationController!.parentViewController as! DraggableContainerViewController
//                print(dcvc.addToken(token))
//                
//                
//                let status = PFObject(className: "ButtomImages")
//                status["imageNumber"] = token.imageNumber
//                status["symbol"] = token.symbol
//                status["function"] = token.functionReplace ?? ""
//                
//                status.deleteInBackgroundWithBlock( { (success, error) -> Void in
//                    if success {
//                        completion(success: success)
//                        
//                    } else {
//                        completion(success: false)
//                    }
//                })
//            }
//        }
//    }
	
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buttonImages.count
    }
    
                /// GET THE IMAGE FROM PARSE AND LOAD IT INTO THE TABLEVIEW
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ButtonTableViewCell.identifier(), forIndexPath: indexPath) as! ButtonTableViewCell
        
        let buttonImage = self.buttonImages[indexPath.row]
//        let symbol = buttonImage["symbol"] as? String
		
//        cell.symbol.text = symbol
		
		
		
//        if let imageFile = buttonImage["Image"] as? PFFile {
//            imageFile.getDataInBackgroundWithBlock({ (data, error) -> Void in
//                guard let data = data else {return}
//                cell.buttonImage.image = UIImage(data: data)
//            })
//	}
//		if let imageNumber = buttonImage["imageNumber"] as? Int
//		{
//			cell.buttonImage.image = kImages[imageNumber]
//		}
		
		cell.dcvc = navigationController!.parentViewController as! DraggableContainerViewController
		cell.reloadClosure =
		{
			self.buttonTableView.reloadData()
		}
		cell.token = Token(symbol: buttonImage["symbol"] as! String, order: kOrderFunc, imageNumber: buttonImage["imageNumber"] as! Int, effect0: nil, effect1: nil, effect2: nil, functionReplace: (buttonImage["function"] as? String) ?? "")
        return cell
    }
    
    // MARK:   SEARCH BAR
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {return}
        self.getParseData(searchText)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.getParseData()
    }
}
