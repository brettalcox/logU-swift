//
//  MaxesTableViewController.swift
//  logU
//
//  Created by Brett Alcox on 1/19/16.
//  Copyright © 2016 Brett Alcox. All rights reserved.
//

import UIKit

var LiftType: [String]! = []
var Maxes: [String]! = []

class MaxesTableViewController: UITableViewController {
    
    let url_to_request:String = "https://loguapp.com/swift8.php"
    
    var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        
        if shouldUpdateMax {
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
            shouldUpdateMax = false
        }
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if shouldUpdateMax {
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
            shouldUpdateMax = false
        }
        self.tableView.reloadData()
    }
    
    func loadAfter(object: Array<Dictionary<String, String>>) {
        dataAfter = object
        
        LiftType = []
        Maxes = []
        
        for i in 0..<dataAfter.count {
            LiftType.append(dataAfter[i]["lift"]!)
            Maxes.append(dataAfter[i]["max"]!)
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
        return LiftType.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        // Allocates a Table View Cell
        let aCell =
        self.tableView.dequeueReusableCellWithIdentifier("cell",
            forIndexPath: indexPath) as! MaxesTableViewCell
        // Sets the text of the Label in the Table View Cell
        
        let lift = LiftType[indexPath.row]
        let max = Maxes[indexPath.row]
        
        aCell.liftLabel.text = lift
        aCell.weightLabel.text = max
        return aCell
    }
}
