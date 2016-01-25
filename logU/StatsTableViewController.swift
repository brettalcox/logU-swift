//
//  StatsTableViewController.swift
//  logU
//
//  Created by Brett Alcox on 1/19/16.
//  Copyright © 2016 Brett Alcox. All rights reserved.
//

import UIKit

class StatsTableViewController: UITableViewController {
    
    var objects = [String]()

    override func viewDidLoad() {
        self.objects.append("One Rep Maxes")
        self.objects.append("Weekly Poundage")
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section:
        Int) -> Int
    {
        return self.objects.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        // Allocates a Table View Cell
        let aCell =
        self.tableView.dequeueReusableCellWithIdentifier("cell",
            forIndexPath: indexPath) as! StatsTableViewCell
        // Sets the text of the Label in the Table View Cell
        aCell.titleLabel.text = self.objects[indexPath.row]
        return aCell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if indexPath.row == 0 {
            self.performSegueWithIdentifier("showMaxes", sender: self)
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
        if indexPath.row == 1 {
            self.performSegueWithIdentifier("showPoundage", sender: self)
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)

        }
    }
}
