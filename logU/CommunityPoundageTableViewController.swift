//
//  CommunityPoundageTableViewController.swift
//  logU
//
//  Created by Brett Alcox on 3/24/16.
//  Copyright © 2016 Brett Alcox. All rights reserved.
//

//
//  PoundageTableViewController.swift
//  logU
//
//  Created by Brett Alcox on 1/24/16.
//  Copyright © 2016 Brett Alcox. All rights reserved.
//

import UIKit

var commWeeks: [String]! = []
var commPoundage: [String]! = []

class CommunityPoundageTableViewController: UITableViewController {
    
    let url_to_request:String = "https://loguapp.com/community_poundage2.php"
    
    var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        
        if shouldUpdateCommWeek {
            if Reachability.isConnectedToNetwork() {
                
                indicator = UIActivityIndicatorView()
                var frame = indicator.frame
                frame.origin.x = view.frame.size.width / 2
                frame.origin.y = (view.frame.size.height / 2) - 40
                indicator.frame = frame
                indicator.activityIndicatorViewStyle = .Gray
                indicator.startAnimating()
                view.addSubview(indicator)
                
                dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                    
                    GraphData().dataOfLifting(self.url_to_request, completion: { jsonString in
                        dataAfter = jsonString
                        dispatch_async(dispatch_get_main_queue()) {
                            self.loadAfter(dataAfter)
                        }
                    })
                }
            }
            shouldUpdateCommWeek = false
        }
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if shouldUpdateCommWeek {
            if Reachability.isConnectedToNetwork() {
                
                indicator = UIActivityIndicatorView()
                var frame = indicator.frame
                frame.origin.x = view.frame.size.width / 2
                frame.origin.y = (view.frame.size.height / 2) - 40
                indicator.frame = frame
                indicator.activityIndicatorViewStyle = .Gray
                indicator.startAnimating()
                view.addSubview(indicator)
                
                dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                    
                    GraphData().dataOfLifting(self.url_to_request, completion: { jsonString in
                        dataAfter = jsonString
                        dispatch_async(dispatch_get_main_queue()) {
                            self.loadAfter(dataAfter)
                        }
                    })
                }
            }
            shouldUpdateCommWeek = false
        }
        self.tableView.reloadData()
    }
    
    func loadAfter(object: Array<Dictionary<String, String>>) {
        dataAfter = object
        
        commWeeks = []
        commPoundage = []
        
        for i in 0..<dataAfter.count {
            commWeeks.append(dataAfter[i]["week"]!)
            commPoundage.append(dataAfter[i]["pounds"]!)
        }
        self.tableView.reloadData()
        indicator.stopAnimating()
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section:
        Int) -> Int
    {
        return commWeeks.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        // Allocates a Table View Cell
        let aCell =
        self.tableView.dequeueReusableCellWithIdentifier("cell",
            forIndexPath: indexPath) as! CommunityPoundageTableViewCell
        // Sets the text of the Label in the Table View Cell
        
        let week = commWeeks[indexPath.row]
        let poundage = commPoundage[indexPath.row]
        
        aCell.commWeekLabel.text = "Week " + week
        aCell.commPoundageLabel.text = poundage
        return aCell
    }
    
}
