//
//  ParentPageViewController.swift
//  CTCalc
//
//  Created by Francisco Ragland Jr on 11/19/15.
//  Copyright © 2015 CTC. All rights reserved.
//

import UIKit

class ParentPageViewController: UIViewController, UIPageViewControllerDataSource {
    
    var pageViewController = UIPageViewController()
    var pageTitles: NSArray!
    var pageImages: NSArray!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageTitles = NSArray(objects: "Welcome","How to Make Functions")
        
        self.pageImages = NSArray(objects: "dunkleosteus", "nautilus")
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        
        self.pageViewController.dataSource = self
        
        let startVC = self.viewControllerAtIndex(0) as TutorialDisplayViewController
        let viewControllers = NSArray(object: startVC)
        
        self.pageViewController.setViewControllers(viewControllers as? [UIViewController], direction: .Forward, animated: true, completion: nil)
        
        self.pageViewController.view.frame = CGRectMake(0, 10, self.view.frame.width, self.view.frame.size.height - 60)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissButtonPressed(sender: AnyObject) {
        
    }
    
    func viewControllerAtIndex(index: Int) -> TutorialDisplayViewController {
        
        if ((self.pageTitles.count == 0) || index >= self.pageTitles.count) {
            return TutorialDisplayViewController()
        }
        
        let vc: TutorialDisplayViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TutorialDisplayViewController") as! TutorialDisplayViewController
        
        vc.imageFile = self.pageImages[index]as! String
        vc.titleText = self.pageTitles[index]as! String
        vc.pageIndex = index
        
        return vc
        
    }
    
    //MARK: PageViewController DataSource
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! TutorialDisplayViewController
        var index = vc.pageIndex as Int
        
        if (index == 0 || index == NSNotFound) {
            return nil
        }
        
        index--
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! TutorialDisplayViewController
        var index = vc.pageIndex as Int
        
        if (index == NSNotFound){
            return nil
        }
        
        index++
        
        if (index == self.pageTitles.count) {
            return nil
        }
        
        return self.viewControllerAtIndex(index)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pageTitles.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    
    
    
    
    
    
    
    


}
