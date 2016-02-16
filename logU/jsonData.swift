//
//  jsonData.swift
//  logU
//
//  Created by Brett on 1/15/16.
//  Copyright © 2016 Brett. All rights reserved.
//

import Foundation

class JsonData {
    
    var myData: Array<Dictionary<String, String>> = []
    
    var Lifts: [String] = []
    var Dates: [String] = []
    var Weights: [String] = []
    var Sets: [String] = []
    var Reps: [String] = []
    var Ids: [String] = []
    
    func passValues(data: Array<Dictionary<String, String>>) {

        myData = data
    }
    
    func dataOfLift(completion: (Array<Dictionary<String, String>>) -> ()) {//url: String) -> ([String], [String], [String], [String], [String], [String])? {
        
        let urlName:NSURL = NSURL(string: "https:loguapp.com/swift6.php")!
        let session = NSURLSession.sharedSession()
        
        let data = NSData(contentsOfURL: NSURL(string: "https:/loguapp.com/swift6.php")!)
        let user = "username=\(NSUserDefaults.standardUserDefaults().valueForKey("USERNAME")!)"
        let queryParam = user.dataUsingEncoding(NSUTF8StringEncoding)
        let userData:NSData = user.dataUsingEncoding(NSASCIIStringEncoding)!
        
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
                    
                    myData = jsonArray!
                    
                } catch let error as NSError {
                }
                completion(Array<Dictionary<String, String>>(myData))
        });
        task.resume()
    }
    
}
