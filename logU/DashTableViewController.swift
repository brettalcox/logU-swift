//
//  DashTableViewController.swift
//
//
//  Created by Brett Alcox on 1/11/16.
//
//

import UIKit

var dataAfter: Array<Dictionary<String, String>> = []

var Lifts: [String]! = []
var Dates: [String]! = []
var Weights: [String]! = []
var Sets: [String]! = []
var Reps: [String]! = []
var Ids: [String]! = []

var unfilteredTableData = [DashData]()
var filteredTableData = [DashData]()

class DashTableViewController: UITableViewController, UISearchResultsUpdating {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let url_to_post:String = "https://loguapp.com/swift7.php"
    
    var indicator: UIActivityIndicatorView!
    
    var resultSearchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.placeholder = "Search Lift by Date"
            controller.searchBar.keyboardType = UIKeyboardType.NumbersAndPunctuation
            
            self.tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
        self.navigationController?.extendedLayoutIncludesOpaqueBars = true
        
        // Reload the table
        self.tableView.reloadData()
        
        indicator = UIActivityIndicatorView()
        var frame = indicator.frame
        frame.origin.x = view.frame.size.width / 2
        frame.origin.y = (view.frame.size.height / 2) - 40
        indicator.frame = frame
        indicator.activityIndicatorViewStyle = .Gray
        indicator.startAnimating()
        view.addSubview(indicator)
        
        if Reachability.isConnectedToNetwork() {
            
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
        
            OfflineRequest().OfflineFetchSubmit()
            OfflineRequest().OfflineFetchDelete()
            
            JsonData().dataOfLift({ jsonString in
                dataAfter = jsonString
                dispatch_async(dispatch_get_main_queue()) {
                    self.loadAfter(dataAfter)
                }
            })
          }
        }
        
        if !Reachability.isConnectedToNetwork() {
            var Lifting = OfflineRequest().OfflineFetch()
            
            var tableInsert = [DashData]()
            for i in 0..<Lifting.count {
                
                tableInsert.append(DashData(date: lifting[i].valueForKey("date")! as! String, lift: lifting[i].valueForKey("lift")! as! String, set: lifting[i].valueForKey("sets")! as! String, rep: lifting[i].valueForKey("reps")! as! String, weight: lifting[i].valueForKey("weight")! as! String, id: "0"))
                unfilteredTableData.append(tableInsert[i])

            }
            indicator.stopAnimating()
            
            self.tableView.reloadData()
        }
        
        navigationItem.leftBarButtonItem = editButtonItem()
        
    }
    
    func loadAfter(object: Array<Dictionary<String, String>>) {
        dataAfter = object

        unfilteredTableData = []
        for i in 0..<dataAfter.count {
            
            unfilteredTableData.append(DashData(date: dataAfter[i]["date"]!, lift: dataAfter[i]["lift"]!, set: dataAfter[i]["sets"]!, rep: dataAfter[i]["reps"]!, weight: dataAfter[i]["weight"]!, id: dataAfter[i]["id"]!))
        }
        self.tableView.reloadData()
        indicator.stopAnimating()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.definesPresentationContext = true
        self.navigationController?.extendedLayoutIncludesOpaqueBars = true

        self.tableView.reloadData()
        
        if shouldUpdateDash {
            if Reachability.isConnectedToNetwork() {
                dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
            
                    OfflineRequest().OfflineFetchSubmit()
                    OfflineRequest().OfflineFetchDelete()
            
                    JsonData().dataOfLift({ jsonString in
                        dataAfter = jsonString
                        dispatch_async(dispatch_get_main_queue()) {
                            self.loadAfter(dataAfter)
                        }
                    })
                }
            }
            shouldUpdateDash = false
        }

        self.tableView.reloadData()
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
        if (self.resultSearchController.active) {
            return filteredTableData.count
        }
        else {
        return unfilteredTableData.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! LiftTableViewCell

        if (self.resultSearchController.active) {

            cell.dateLabel.text = filteredTableData[indexPath.row].date
            cell.liftLabel.text = filteredTableData[indexPath.row].lift
            cell.poundsLabel.text = filteredTableData[indexPath.row].weight
            cell.setsRepsLabel.text = filteredTableData[indexPath.row].set + "x" + filteredTableData[indexPath.row].rep
            cell.idLabel.text = filteredTableData[indexPath.row].id

        }
        else {
            
            cell.dateLabel.text = unfilteredTableData[indexPath.row].date
            cell.liftLabel.text = unfilteredTableData[indexPath.row].lift
            cell.poundsLabel.text = unfilteredTableData[indexPath.row].weight
            cell.setsRepsLabel.text = unfilteredTableData[indexPath.row].set + "x" + unfilteredTableData[indexPath.row].rep
            cell.idLabel.text = unfilteredTableData[indexPath.row].id
        }
        
        return cell
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredTableData = unfilteredTableData.filter { logs in
            return logs.date.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        self.tableView.reloadData()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        filterContentForSearchText(searchController.searchBar.text!)
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
            let idToDelete = unfilteredTableData[indexPath.row].id
            
            if resultSearchController.active && resultSearchController.searchBar.text != "" {
                let searchIdToDelete = filteredTableData[indexPath.row].id

                if Reachability.isConnectedToNetwork() {
                    dispatch_async(dispatch_get_global_queue(Int   (QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                        self.delete_request(searchIdToDelete)
                    }
                }
                filteredTableData.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)

                shouldUpdateDash = true
                shouldUpdatePoundage = true
                shouldUpdateSquat = true
                shouldUpdateBench = true
                shouldUpdateDeadlift = true
                shouldUpdateMax = true
                shouldUpdateWeek = true
                shouldUpdateStats = true
                shouldUpdateFrequency = true
                
                if Reachability.isConnectedToNetwork() {
                    
                    dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                        
                        OfflineRequest().OfflineFetchSubmit()
                        OfflineRequest().OfflineFetchDelete()
                        
                        JsonData().dataOfLift({ jsonString in
                            dataAfter = jsonString
                            dispatch_async(dispatch_get_main_queue()) {
                                sleep(1)
                                self.loadAfter(dataAfter)
                            }
                        })
                    }
                }
                
            } else {

                if Reachability.isConnectedToNetwork() {
                    dispatch_async(dispatch_get_global_queue(Int   (QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                            self.delete_request(idToDelete)
                    }
                }

                if !Reachability.isConnectedToNetwork() {
                    OfflineRequest.coreDataDelete(idToDelete, date: unfilteredTableData[indexPath.row].date, lift: unfilteredTableData[indexPath.row].lift, sets: unfilteredTableData[indexPath.row].set, reps: unfilteredTableData[indexPath.row].rep, weight: unfilteredTableData[indexPath.row].weight)
                }
            
                unfilteredTableData.removeAtIndex(indexPath.row)

                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
                shouldUpdateDash = true
                shouldUpdatePoundage = true
                shouldUpdateSquat = true
                shouldUpdateBench = true
                shouldUpdateDeadlift = true
                shouldUpdateMax = true
                shouldUpdateWeek = true
                shouldUpdateStats = true
                shouldUpdateFrequency = true
            }
            
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
                    return
                }
                
                let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            }
        );

        task.resume()
        
    }
    
    func OfflineTableInsert(date: String, lift: String, set: String, rep: String, weight: String) {
        
        let tableInsert = DashData(date: date, lift: lift, set: set, rep: rep, weight: weight, id: "0")
        
        unfilteredTableData.insert(tableInsert, atIndex: 0)
    }
    
}
