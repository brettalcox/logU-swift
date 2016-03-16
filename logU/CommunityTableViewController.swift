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
import FBAnnotationClusteringSwift

var mapCoords: Array<Dictionary<String, String>> = []

class CommunityTableViewController: UITableViewController {

    @IBOutlet weak var communityMap: MKMapView!
    var array:[FBAnnotation] = []
    
    let clusteringManager = FBClusteringManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getGpsCoordinates("https://loguapp.com/request_coords.php", completion: { jsonString in
            mapCoords = jsonString
            dispatch_sync(dispatch_get_main_queue(), {
                self.loadMapCoords(mapCoords)
                self.communityMap.delegate = self
            })
        })

    }
    
    override func viewDidAppear(animated: Bool) {
        if shouldUpdateMap {
            loadMap()
            shouldUpdateMap = false
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.communityMap.delegate = nil
        self.clusteringManager.delegate = nil
        
        self.communityMap.mapType = MKMapType.Satellite
        self.communityMap.mapType = MKMapType.Hybrid
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 3
    }
    
    func loadMap() {
        getGpsCoordinates("https://loguapp.com/request_coords.php", completion: { jsonString in
            mapCoords = jsonString
            dispatch_sync(dispatch_get_main_queue(), {
                self.loadMapCoords(mapCoords)
                self.communityMap.delegate = self
            })
        })

    }
    
    func loadMapCoords(object: Array<Dictionary<String, String>>) {

        if object.count != 0 {
            array = []
            
            for i in 0..<object.count {
                let pin: FBAnnotation = FBAnnotation()

                pin.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(object[i]["latitude"]!)!, longitude: CLLocationDegrees(object[i]["longitude"]!)!)
                array.append(pin)
            }
            
            clusteringManager.addAnnotations(array)

        }
    }
        
    func getGpsCoordinates(url: String, completion: (Array<Dictionary<String, String>>) -> ()) {
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
                    }
                    
                } catch let error as NSError {
                }
                completion(Array<Dictionary<String, String>>(myData))
                
        });
        task.resume()
    }

}

extension CommunityTableViewController : FBClusteringManagerDelegate {
    
    func cellSizeFactorForCoordinator(coordinator:FBClusteringManager) -> CGFloat{
        return 1.0
    }
    
}

extension CommunityTableViewController : MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool){
        
        NSOperationQueue().addOperationWithBlock({
            
            let mapBoundsWidth = Double(self.communityMap.bounds.size.width)
            
            let mapRectWidth:Double = self.communityMap.visibleMapRect.size.width
            
            let scale:Double = mapBoundsWidth / mapRectWidth
            
            let annotationArray = self.clusteringManager.clusteredAnnotationsWithinMapRect(self.communityMap.visibleMapRect, withZoomScale:scale)
            
            self.clusteringManager.displayAnnotations(annotationArray, onMapView:self.communityMap)
            
        })
        
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        var reuseId = ""
        
        if annotation.isKindOfClass(FBAnnotationCluster) {
            
            reuseId = "Cluster"
            var clusterView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
            clusterView = FBAnnotationClusterView(annotation: annotation, reuseIdentifier: reuseId, options: nil)
            
            return clusterView
            
        } else {
            
            reuseId = "Pin"
            var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            
            
            pinView!.pinTintColor = UIColor(red: 0/255.0, green: 152/255.0, blue: 255/255.0, alpha: 1.0)
            
            return pinView
        }
        
    }
    
}
