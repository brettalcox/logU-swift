//
//  CommunityTableViewController.swift
//  logU
//
//  Created by Brett Alcox on 3/11/16.
//  Copyright © 2016 Brett Alcox. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

var mapCoords: Array<Dictionary<String, String>> = []

class CommunityTableViewController: UITableViewController {

    @IBOutlet weak var communityMap: MKMapView!
    var dataPoints: [CommunityPoints] = []
    
    override func viewDidLoad() {
        
        getGpsCoordinates("https://loguapp.com/request_coords.php", completion: { jsonString in
            mapCoords = jsonString
            dispatch_sync(dispatch_get_main_queue(), {
                self.loadMapCoords(mapCoords)
            })
        })
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 3
    }
    
    func loadMapCoords(object: Array<Dictionary<String, String>>) {
        print(object)
        if object.count != 0 {
            dataPoints = []
            var coordinate: CLLocationCoordinate2D
            
            for i in 0..<object.count {
                print(object[i]["latitude"])
                print(object[i]["longitude"])

                dataPoints.append(CommunityPoints(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(object[i]["latitude"]!)!, longitude: CLLocationDegrees(object[i]["longitude"]!)!)))
            }
            
            for i in 0..<dataPoints.count {
                communityMap.addAnnotation(dataPoints[i])
            }
        }
    }
        
    func getGpsCoordinates(url: String, completion: (Array<Dictionary<String, String>>) -> ()) {
        print("titty piss")
        let urlName:NSURL = NSURL(string: url)!
        let session = NSURLSession.sharedSession()
        let data = NSData(contentsOfURL: NSURL(string: url)!)
        let queryParam = "none".dataUsingEncoding(NSUTF8StringEncoding)
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: urlName)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        let task = session.uploadTaskWithRequest(request, fromData: queryParam!, completionHandler:
            {(data,response,error) in
                
                guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                    return
                }
                var myData: Array<Dictionary<String, String>> = []
                do {
                    let jsonArray = try NSJSONSerialization.JSONObjectWithData(data!, options: [NSJSONReadingOptions.MutableContainers, NSJSONReadingOptions.AllowFragments]) as? Array<Dictionary<String, String>>
                    if jsonArray != nil {
                        myData = jsonArray!
                        print(myData)
                    }
                    
                } catch let error as NSError {
                }
                completion(Array<Dictionary<String, String>>(myData))
                
        });
        task.resume()
    }

}
