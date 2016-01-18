//
//  jsonData.swift
//  logU
//
//  Created by Brett on 1/15/16.
//  Copyright © 2016 Brett. All rights reserved.
//

import Foundation

class jsonData {
    
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
                    print("error")
                    return
                }

                //let dataString = String(data: data!, encoding: NSUTF8StringEncoding)
                //print(dataString)
                //print("fuck my shitter1")
                var myData: Array<Dictionary<String, String>> = []
                do {
                    let jsonArray = try NSJSONSerialization.JSONObjectWithData(data!, options: [NSJSONReadingOptions.MutableContainers, NSJSONReadingOptions.AllowFragments]) as? Array<Dictionary<String, String>>
                    //print("json := \(jsonArray)")
                        jsonData().passValues(jsonArray!)
                    
                    //print(NSUserDefaults.standardUserDefaults().valueForKey("DASHDATA"))
                    myData = jsonArray!
                    
                } catch let error as NSError {
                    print(error.localizedDescription)
                    //return nil;
                }
                //print(myData)
                completion(Array<Dictionary<String, String>>(myData))
        });
        task.resume()
        /*
        for i in 0..<Dates.count {
        

            var dashJson: Array<Dictionary<String, String>> = NSUserDefaults.standardUserDefaults().valueForKey("DASHDATA") as! Array<Dictionary<String, String>>
            //print(myData)
            
            Dates.append(dashJson[i]["date"]!)
            Lifts.append(dashJson[i]["lift"]!)
            Weights.append(dashJson[i]["weight"]!)
            Sets.append(dashJson[i]["sets"]!)
            Reps.append(dashJson[i]["reps"]!)
            Ids.append(dashJson[i]["id"]!)
            
        }
*/
        /*
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
        *///return (Dates, Lifts, Weights, Sets, Reps, Ids)

    }
    
}
