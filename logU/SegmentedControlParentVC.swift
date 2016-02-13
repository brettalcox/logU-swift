//
//  SegmentedControlParentVC.swift
//  logU
//
//  Created by Brett Alcox on 2/13/16.
//  Copyright © 2016 Brett Alcox. All rights reserved.
//

import UIKit

class ParentViewController: UIViewController {
    
    enum TabIndex : Int {
        case FirstChildTab = 0
        case SecondChildTab = 1
        case ThirdChildTab = 2
        case FourthChildTab = 3
    }
    
    var currentTab: Int?
    
    @IBOutlet weak var segmentedControl: GraphSegmented!
    @IBOutlet weak var contentView: UIView!
    
    var currentViewController: UIViewController?
    lazy var firstChildTabVC: UIViewController? = {
        let firstChildTabVC = self.storyboard?.instantiateViewControllerWithIdentifier("FirstViewControllerId")
        return firstChildTabVC
    }()
    lazy var secondChildTabVC : UIViewController? = {
        let secondChildTabVC = self.storyboard?.instantiateViewControllerWithIdentifier("SecondViewControllerId")
        return secondChildTabVC
    }()
    lazy var thirdChildTabVC : UIViewController? = {
        let thirdChildTabVC = self.storyboard?.instantiateViewControllerWithIdentifier("ThirdViewControllerId")
        return thirdChildTabVC
    }()
    lazy var fourthChildTabVC : UIViewController? = {
        let fourthChildTabVC = self.storyboard?.instantiateViewControllerWithIdentifier("FourthViewControllerId")
        return fourthChildTabVC
    }()
    
    
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControl.initUI()
        segmentedControl.selectedSegmentIndex = TabIndex.FirstChildTab.rawValue
        displayCurrentTab(TabIndex.FirstChildTab.rawValue)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if let currentViewController = currentViewController {
            currentViewController.viewWillDisappear(animated)
        }
    }
    
    // MARK: - Switching Tabs Functions
    @IBAction func switchTabs(sender: UISegmentedControl) {
    
        self.currentViewController!.view.removeFromSuperview()
        self.currentViewController!.removeFromParentViewController()
        displayCurrentTab(sender.selectedSegmentIndex)
    }
    
    func displayCurrentTab(tabIndex: Int){
        if let vc = viewControllerForSelectedSegmentIndex(tabIndex) {
            
            currentTab = tabIndex
            
            self.addChildViewController(vc)
            vc.didMoveToParentViewController(self)
            
            vc.view.frame = self.contentView.bounds
            self.contentView.addSubview(vc.view)
            self.currentViewController = vc
        }
    }
    
    func viewControllerForSelectedSegmentIndex(index: Int) -> UIViewController? {
        var vc: UIViewController?
        switch index {
        case TabIndex.FirstChildTab.rawValue :
            vc = firstChildTabVC
        case TabIndex.SecondChildTab.rawValue :
            vc = secondChildTabVC
        case TabIndex.ThirdChildTab.rawValue :
            vc = thirdChildTabVC
        case TabIndex.FourthChildTab.rawValue :
            vc = fourthChildTabVC
        default:
            return nil
        }
        
        return vc
    }
}
