//
//  DashTableViewController.swift
//  
//
//  Created by Brett Alcox on 1/11/16.
//
//

import UIKit

class DashTableViewController: UITableViewController {

    var Lifts: [String]! = []
    var Dates: [String]! = []
    var Weights: [String]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let (dates, lifts, weights) = dataOfLift("https://loguapp.com/swift6.php")!
        
        Dates = dates
        Lifts = lifts
        Weights = weights
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
        let (dates, lifts, weights) = dataOfLift("https://loguapp.com/swift6.php")!
        
        Dates = dates
        Lifts = lifts
        Weights = weights
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Dates.count
    }

    func dataOfLift(url: String) -> ([String], [String], [String])? {
        
        let data = NSData(contentsOfURL: NSURL(string:url)!)
        var date : [String] = []
        var lift : [String] = []
        var weight : [String] = []
        
        do {
            let jsonArray = try NSJSONSerialization.JSONObjectWithData(data!, options: [NSJSONReadingOptions.MutableContainers, NSJSONReadingOptions.AllowFragments]) as? Array<Dictionary<String, String>>
            print("json := \(jsonArray)")
            
            for i in 0..<jsonArray!.count {
                date.append(jsonArray![i]["date"]!)
                lift.append(jsonArray![i]["lift"]!)
                weight.append(jsonArray![i]["weight"]!)
                
            }
            
            for i in 0..<date.count {
                print(date[i])
                print(lift[i])
                print(weight[i])
            }
            
            return (date, lift, weight)
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil;
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! LiftTableViewCell

        let lift = Lifts[indexPath.row]
        let date = Dates[indexPath.row]
        let weight = Weights[indexPath.row]
        
        cell.liftLabel.text = lift
        cell.dateLabel.text = date
        cell.poundsLabel.text = weight
        // Configure the cell...

        return cell
    }

    @IBAction func unwindToDashboard(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        
    }
        
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
