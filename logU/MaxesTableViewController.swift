//
//  MaxesTableViewController.swift
//  logU
//
//  Created by Brett Alcox on 1/19/16.
//  Copyright © 2016 Brett Alcox. All rights reserved.
//

import UIKit

class MaxesTableViewController: UITableViewController {
    
    let url_to_request:String = "https://loguapp.com/swift8.php"

    
    var Lifts: [String]! = []
    var Maxes: [String]! = []
    
    override func viewDidLoad() {
        if Reachability.isConnectedToNetwork() {
            dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                
                GraphData().dataOfLifting(self.url_to_request, completion: { jsonString in
                    dataAfter = jsonString
                    dispatch_async(dispatch_get_main_queue()) {
                        self.loadAfter(dataAfter)
                    }
                })
            }
        }

    }
    
    override func viewDidAppear(animated: Bool) {
        if Reachability.isConnectedToNetwork() {
            dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
            
                GraphData().dataOfLifting(self.url_to_request, completion: { jsonString in
                    dataAfter = jsonString
                    dispatch_async(dispatch_get_main_queue()) {
                        self.loadAfter(dataAfter)
                    }
                })
            }
        }

    }
    
    func loadAfter(object: Array<Dictionary<String, String>>) {
        dataAfter = object
        
        Lifts = []
        Maxes = []
        
        for i in 0..<dataAfter.count {
            Lifts.append(dataAfter[i]["lift"]!)
            Maxes.append(dataAfter[i]["max"]!)
        }
        self.tableView.reloadData()
    }

    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section:
        Int) -> Int
    {
        return Lifts.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        // Allocates a Table View Cell
        let aCell =
        self.tableView.dequeueReusableCellWithIdentifier("cell",
            forIndexPath: indexPath) as! MaxesTableViewCell
        // Sets the text of the Label in the Table View Cell
        
        let lift = Lifts[indexPath.row]
        let max = Maxes[indexPath.row]
        
        aCell.liftLabel.text = lift
        aCell.weightLabel.text = max
        return aCell
    }
}
