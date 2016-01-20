//
//  DashTableViewController.swift
//
//
//  Created by Brett Alcox on 1/11/16.
//
//

import UIKit

var dataAfter: Array<Dictionary<String, String>> = []

class DashTableViewController: UITableViewController {
    
    let url_to_post:String = "https://loguapp.com/swift7.php"
    
    var Lifts: [String]! = []
    var Dates: [String]! = []
    var Weights: [String]! = []
    var Sets: [String]! = []
    var Reps: [String]! = []
    var Ids: [String]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    print(NSUserDefaults.standardUserDefaults().valueForKey("USERNAME")!)
        
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
        
            JsonData().dataOfLift({ jsonString in
                dataAfter = jsonString
                dispatch_async(dispatch_get_main_queue()) {
                    self.loadAfter(dataAfter)
                }
            })
        }
        //self.tableView.reloadData()

        navigationItem.leftBarButtonItem = editButtonItem()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func loadAfter(object: Array<Dictionary<String, String>>) {
        dataAfter = object
        
        Dates = []
        Lifts = []
        Weights = []
        Sets = []
        Reps = []
        Ids = []
        
        for i in 0..<dataAfter.count {
            Dates.append(dataAfter[i]["date"]!)
            Lifts.append(dataAfter[i]["lift"]!)
            Weights.append(dataAfter[i]["weight"]!)
            Sets.append(dataAfter[i]["sets"]!)
            Reps.append(dataAfter[i]["reps"]!)
            Ids.append(dataAfter[i]["id"]!)
        }
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {

        //self.tableView.reloadData()
        
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
            JsonData().dataOfLift({ jsonString in
                dataAfter = jsonString
                dispatch_async(dispatch_get_main_queue()) {
                    self.loadAfter(dataAfter)
                }
            })
        }
        self.tableView.reloadData()
        //sleep(1)
        //self.tableView.reloadData()
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
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! LiftTableViewCell
        
        let lift = Lifts[indexPath.row]
        let date = Dates[indexPath.row]
        let weight = Weights[indexPath.row]
        let set = Sets[indexPath.row]
        let rep = Reps[indexPath.row]
        let id = Ids[indexPath.row]
        
        cell.liftLabel.text = lift
        cell.dateLabel.text = date
        cell.poundsLabel.text = weight
        cell.setsRepsLabel.text = set + "x" + rep
        cell.idLabel.text = id
        // Configure the cell...
        
        return cell
    }
    
    @IBAction func unwindToDashboard(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let idToDelete = Ids[indexPath.row]
            
            dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                    self.delete_request(idToDelete)
            }
            
            self.Lifts.removeAtIndex(indexPath.row)
            self.Dates.removeAtIndex(indexPath.row)
            self.Weights.removeAtIndex(indexPath.row)
            self.Sets.removeAtIndex(indexPath.row)
            self.Reps.removeAtIndex(indexPath.row)
            self.Ids.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func delete_request(theId: String)
    {
        let url:NSURL = NSURL(string: url_to_post)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        let query = "id=\(theId)".dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.uploadTaskWithRequest(request, fromData: query, completionHandler:
            {(data,response,error) in
                
                guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                    print("error")
                    return
                }
                
                let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print(dataString)
            }
        );
        
        task.resume()
        
    }
    
    
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
