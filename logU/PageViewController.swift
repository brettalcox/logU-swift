//
//  PageViewController.swift
//  logU
//
//  Created by Brett Alcox on 1/11/16.
//  Copyright © 2016 Brett. All rights reserved.
//

import UIKit
import Foundation


class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    private var pages: [UIViewController]!
    private var startingViewController: UIViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.view.backgroundColor = UIColor.whiteColor()
        
        let appearence = UIPageControl.appearance()
        appearence.pageIndicatorTintColor = UIColor.lightGrayColor()
        appearence.currentPageIndicatorTintColor = UIColor.grayColor()
        
        self.dataSource = self
        self.delegate = self
        
        self.pages = [
            self.storyboard!.instantiateViewControllerWithIdentifier("FirstNavigationController") as! UINavigationController,
            self.storyboard!.instantiateViewControllerWithIdentifier("SecondNavigationController") as! UINavigationController,
            self.storyboard!.instantiateViewControllerWithIdentifier("ThirdNavigationController") as! UINavigationController,
            self.storyboard!.instantiateViewControllerWithIdentifier("FourthNavigationController") as! UINavigationController
        ]
        
        startingViewController = self.pages.first! as UIViewController
        self.setViewControllers([startingViewController], direction: .Forward, animated: false, completion: nil)
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.automaticallyAdjustsScrollViewInsets = false;
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let index = (self.pages as NSArray).indexOfObject(viewController)
        
        // if currently displaying last view controller, return nil to indicate that there is no next view controller
        return (index == self.pages.count - 1 ? nil : self.pages[index + 1])
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let index = (self.pages as NSArray).indexOfObject(viewController)
        
        // if currently displaying first view controller, return nil to indicate that there is no previous view controller
        return (index == 0 ? nil : self.pages[index - 1])
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 4
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            firstViewControllerIndex = pages.indexOf(firstViewController) else {
                return 0
        }
        
        return firstViewControllerIndex
    }
    
}