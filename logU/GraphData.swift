//
//  GraphData.swift
//  logU
//
//  Created by Brett Alcox on 1/17/16.
//  Copyright © 2016 Brett. All rights reserved.
//

import Foundation
import UIKit


class GraphData {
    
    let url_to_request:String = "https://loguapp.com/swift.php"
    let url_to_post:String = "https://loguapp.com/swift2.php"
    
    var graphWeek : [String]! = []
    var graphPoundage : [Int]! = []
    
    func dataOfWeeklyPoundage(url: String) -> ([String], [Double])? {
        
        //let urlString = "https://loguapp.com/swift.php"
        let data = NSData(contentsOfURL: NSURL(string:url)!)
        var week : [String] = []
        var poundage : [Double] = []
        
        do {
            let jsonArray = try NSJSONSerialization.JSONObjectWithData(data!, options: [NSJSONReadingOptions.MutableContainers, NSJSONReadingOptions.AllowFragments]) as? Array<Dictionary<String, String>>
            //print("json := \(jsonArray)")
            
            for i in 0..<jsonArray!.count {
                week.append(jsonArray![i]["week"]!)
                poundage.append(Double(jsonArray![i]["pounds"]!)!)
                
            }
            
            for i in 0..<week.count {
                //print(week[i])
                //print(poundage[i])
            }
            
            return (week, poundage)
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil;
        }
    }
    
    func dataOfLift(url: String) -> ([String], [Double])? {
        
        let data = NSData(contentsOfURL: NSURL(string:url)!)
        var date : [String] = []
        var weight : [Double] = []
        
        do {
            let jsonArray = try NSJSONSerialization.JSONObjectWithData(data!, options: [NSJSONReadingOptions.MutableContainers, NSJSONReadingOptions.AllowFragments]) as? Array<Dictionary<String, String>>
            //print("json := \(jsonArray)")
            
            for i in 0..<jsonArray!.count {
                date.append(jsonArray![i]["date"]!)
                weight.append(Double(jsonArray![i]["weight"]!)!)
                
            }
            
            for i in 0..<date.count {
                //print(date[i])
                //print(weight[i])
            }
            
            return (date, weight)
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil;
        }
    }
}