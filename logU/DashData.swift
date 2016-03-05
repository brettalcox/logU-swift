//
//  DashData.swift
//  logU
//
//  Created by Brett Alcox on 1/26/16.
//  Copyright © 2016 Brett Alcox. All rights reserved.
//

import UIKit

class DashData {

    var date: String
    var lift: String
    var set: String
    var rep: String
    var weight: String
    var id: String
    var intensity: String
    
    init (date: String, lift: String, set: String, rep: String, weight: String, id: String, intensity: String) {
        self.date = date
        self.lift = lift
        self.set = set
        self.rep = rep
        self.weight = weight
        self.id = id
        self.intensity = intensity
    }
}
