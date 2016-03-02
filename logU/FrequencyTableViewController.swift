//
//  FrequencyTableViewController.swift
//  logU
//
//  Created by Brett Alcox on 2/25/16.
//  Copyright © 2016 Brett Alcox. All rights reserved.
//

import UIKit

var frequencyWeeks: [String]! = []
var frequency: [String]! = []

class FrequencyTableViewController: UITableViewController {

    let url_to_request:String = "https://loguapp.com/swift_frequency.php"
    var indicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        
        if shouldUpdateFrequency {
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
            shouldUpdateFrequency = false
        }
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if shouldUpdateFrequency {
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
            shouldUpdateFrequency = false
        }
        self.tableView.reloadData()
    }
    
    func loadAfter(object: Array<Dictionary<String, String>>) {
        dataAfter = object
        
        frequencyWeeks = []
        frequency = []
        
        for i in 0..<dataAfter.count {
            frequencyWeeks.append(dataAfter[i]["week"]!)
            frequency.append(dataAfter[i]["frequency"]!)
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
        return frequencyWeeks.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        // Allocates a Table View Cell
        let aCell =
        self.tableView.dequeueReusableCellWithIdentifier("cell",
            forIndexPath: indexPath) as! FrequencyTableViewCell
        // Sets the text of the Label in the Table View Cell
        
        let week = frequencyWeeks[indexPath.row]
        let theFrequency = frequency[indexPath.row]
        
        aCell.weekLabel.text = "Week " + week
        if theFrequency == "1" {
            aCell.frequencyLabel.text = theFrequency + " workout"
        } else {
            aCell.frequencyLabel.text = theFrequency + " workouts"
        }
        return aCell
    }


}
