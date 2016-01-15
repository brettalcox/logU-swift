//
//  jsonData.swift
//  logU
//
//  Created by Brett on 1/15/16.
//  Copyright © 2016 Brett. All rights reserved.
//

import Foundation

class jsonData {
    
    var Lifts: [String] = []
    var Dates: [String] = []
    var Weights: [String] = []
    var Sets: [String] = []
    var Reps: [String] = []
    var Ids: [String] = []
    
    func dataOfLift(url: String) -> ([String], [String], [String], [String], [String], [String])? {
        
        let data = NSData(contentsOfURL: NSURL(string:url)!)
        
        do {
            let jsonArray = try NSJSONSerialization.JSONObjectWithData(data!, options: [NSJSONReadingOptions.MutableContainers, NSJSONReadingOptions.AllowFragments]) as? Array<Dictionary<String, String>>
            //print("json := \(jsonArray)")
            
            for i in 0..<jsonArray!.count {
                Dates.append(jsonArray![i]["date"]!)
                Lifts.append(jsonArray![i]["lift"]!)
                Weights.append(jsonArray![i]["weight"]!)
                Sets.append(jsonArray![i]["sets"]!)
                Reps.append(jsonArray![i]["reps"]!)
                Ids.append(jsonArray![i]["id"]!)
                
            }
            return (Dates, Lifts, Weights, Sets, Reps, Ids)
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil;
        }
    }
    
}