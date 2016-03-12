//
//  CommunityMapPoints.swift
//  logU
//
//  Created by Brett Alcox on 3/11/16.
//  Copyright © 2016 Brett Alcox. All rights reserved.
//

import MapKit

class CommunityPoints: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        
        super.init()
    }
}
