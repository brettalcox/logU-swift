//
//  Settings.swift
//  logU
//
//  Created by Brett Alcox on 1/24/16.
//  Copyright © 2016 Brett Alcox. All rights reserved.
//

import Foundation

class Settings {
    
    let url_to_update = "https://loguapp.com/swift10.php"
    let url_to_get = "https://loguapp.com/swift11.php"
    
    func updateUnit(unit: String, gender: String, bodyweight: String) {
        
            let url:NSURL = NSURL(string: url_to_update)!
            let session = NSURLSession.sharedSession()
            
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
            
            let query = "username=\(NSUserDefaults.standardUserDefaults().valueForKey("USERNAME")!)&unit=\(unit)&gender=\(gender)&bodyweight=\(bodyweight)".dataUsingEncoding(NSUTF8StringEncoding)
            
            let task = session.uploadTaskWithRequest(request, fromData: query, completionHandler:
                {(data,response,error) in
                    
                    guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                        return
                    }
                }
            );
            
            task.resume()
            
    }
    
    func getUnit(username: String, completion: (Array<Dictionary<String, String>>) -> ()) {
        let urlName:NSURL = NSURL(string: url_to_get)!
        let session = NSURLSession.sharedSession()
        let data = NSData(contentsOfURL: NSURL(string: url_to_get)!)
        let user = "username=\(username)"
        let queryParam = user.dataUsingEncoding(NSUTF8StringEncoding)
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

