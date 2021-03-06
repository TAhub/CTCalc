//
//ButtonTableView.swift
//  CTCalc
//
//  Created by Cynthia Whitlatch on 11/16/15.
//  Copyright © 2015 CTC. All rights reserved.
//

import UIKit
import Parse

func checkUser(view:UIView)
{
	if(PFUser.currentUser() == nil)
	{
		//Navigate to login panel
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		let oldRoot = appDelegate.window?.rootViewController
		let mainStoryboard = UIStoryboard(name:"Main", bundle:nil)
		let nav = mainStoryboard.instantiateViewControllerWithIdentifier("login") as! UINavigationController
		let login = nav.viewControllers[0] as! SigninViewController
		
		//frosty background effect
		UIGraphicsBeginImageContext(view.frame.size)
		view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: false)
		let shot = UIImageView(image: UIGraphicsGetImageFromCurrentImageContext())
		UIGraphicsEndImageContext()
		
		let blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
		let vEfV = UIVisualEffectView(effect: blur)
		vEfV.frame = view.frame;
		
		login.view.insertSubview(vEfV, atIndex: 0)
		login.view.insertSubview(shot, atIndex: 0)
		
		login.logged =
		{
			appDelegate.window?.rootViewController = oldRoot
		}
		login.nevermind =
		{
			appDelegate.window?.rootViewController = mainStoryboard.instantiateInitialViewController()
		}
		appDelegate.window?.rootViewController = nav
	}
}

class ButtonTableView: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var buttonTableView: UITableView!
	{
		didSet
		{
			buttonTableView.estimatedRowHeight = 100
			buttonTableView.rowHeight = UITableViewAutomaticDimension
		}
	}
    
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
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		checkUser(self.view)
	}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buttonTableView.dataSource = self
        self.buttonTableView.delegate = self
        
        self.searchBar.showsCancelButton = true
        self.searchBar.delegate = self
    }
    
    func setButtonTableViewEditing(editing: Bool) {
        
        self.buttonTableView.editing = !self.buttonTableView.editing
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.getParseData()
    }
    
    func getParseData(searchTerm: String? = nil) {
        let query = PFQuery(className: "Buttons")
        query.selectKeys(["imageNumber", "symbol", "function", "random", "user"])
        
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
	
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buttonImages.count
    }
    
                /// GET THE IMAGE FROM PARSE AND LOAD IT INTO THE TABLEVIEW
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ButtonTableViewCell.identifier(), forIndexPath: indexPath) as! ButtonTableViewCell
        
        let buttonImage = self.buttonImages[indexPath.row]
		
		cell.dcvc = navigationController!.parentViewController as! DraggableContainerViewController
		cell.reloadClosure =
		{
			self.buttonTableView.reloadData()
		}
		cell.deleteClosure =
		{
			buttonImage.deleteInBackgroundWithBlock()
			{ (success, error) in
				self.getParseData()
			}
		}
		cell.user = buttonImage["user"] as? String
		cell.token = Token(symbol: buttonImage["symbol"] as! String, order: kOrderFunc, imageNumber: buttonImage["imageNumber"] as! Int, effect0: nil, effect1: nil, effect2: nil, functionReplace: (buttonImage["function"] as? String) ?? "")
		cell.token!.random = buttonImage["random"] as? Int ?? 0
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
