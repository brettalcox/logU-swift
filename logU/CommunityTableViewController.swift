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

class CommunityTableViewController: UITableViewController {

    @IBOutlet weak var communityMap: MKMapView!
    var currentLocation: CLLocationCoordinate2D?
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        var dataPoints: [CommunityPoints] = []
        
        //self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        //self.locationManager.requestWhenInUseAuthorization()
        
        //dataPoints.append(CommunityPoints(coordinate: currentLocation!))
        
        //communityMap.addAnnotation(dataPoints[0])
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 3
    }
}
