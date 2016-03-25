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

class CommunityPoundageTableViewController: UITableViewController {
    
    let url_to_request:String = "https://loguapp.com/community_poundage2.php"
    
    var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        
        if shouldUpdateWeek {
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
            shouldUpdateWeek = false
        }
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if shouldUpdateWeek {
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
            shouldUpdateWeek = false
        }
        self.tableView.reloadData()
    }
    
    func loadAfter(object: Array<Dictionary<String, String>>) {
        dataAfter = object
        
        Weeks = []
        Poundage = []
        
        for i in 0..<dataAfter.count {
            Weeks.append(dataAfter[i]["week"]!)
            Poundage.append(dataAfter[i]["pounds"]!)
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
        return Weeks.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        // Allocates a Table View Cell
        let aCell =
        self.tableView.dequeueReusableCellWithIdentifier("cell",
            forIndexPath: indexPath) as! CommunityPoundageTableViewCell
        // Sets the text of the Label in the Table View Cell
        
        let week = Weeks[indexPath.row]
        let poundage = Poundage[indexPath.row]
        
        aCell.weekLabel.text = "Week " + week
        aCell.poundageLabel.text = poundage
        return aCell
    }
    
}
