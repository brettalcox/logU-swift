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
    
    func dataOfWeeklyPoundage(completion: (Array<Dictionary<String, String>>) -> ()) {
        
        //let urlString = "https://loguapp.com/swift.php"
        let urlName:NSURL = NSURL(string: url_to_request)!
        let session = NSURLSession.sharedSession()
        let data = NSData(contentsOfURL: NSURL(string: url_to_request)!)
        let user = "username=\(NSUserDefaults.standardUserDefaults().valueForKey("USERNAME")!)"
        let queryParam = user.dataUsingEncoding(NSUTF8StringEncoding)
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: urlName)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        let task = session.uploadTaskWithRequest(request, fromData: queryParam!, completionHandler:
            {(data,response,error) in
                
                guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                    print("error")
                    return
                }
                var myData: Array<Dictionary<String, String>> = []
                do {
                    let jsonArray = try NSJSONSerialization.JSONObjectWithData(data!, options: [NSJSONReadingOptions.MutableContainers, NSJSONReadingOptions.AllowFragments]) as? Array<Dictionary<String, String>>
                    myData = jsonArray!
            
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                completion(Array<Dictionary<String, String>>(myData))

        });
        task.resume()
    }
    
    func dataOfLift(url: String) -> ([String], [Double])? {
        
        let data = NSData(contentsOfURL: NSURL(string:url)!)
        var date : [String] = []
        var weight : [Double] = []
        
        do {
            let jsonArray = try NSJSONSerialization.JSONObjectWithData(data!, options: [NSJSONReadingOptions.MutableContainers, NSJSONReadingOptions.AllowFragments]) as? Array<Dictionary<String, String>>
            
            for i in 0..<jsonArray!.count {
                date.append(jsonArray![i]["date"]!)
                weight.append(Double(jsonArray![i]["weight"]!)!)
                
            }
            
            return (date, weight)
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil;
        }
    }
}