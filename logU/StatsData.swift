//
//  StatsData.swift
//  logU
//
//  Created by Brett Alcox on 2/3/16.
//  Copyright © 2016 Brett Alcox. All rights reserved.
//

import Foundation


class StatsData {
    
    func averageData(url: String, completion: (Array<Dictionary<String, String>>) -> ()) {
        
        let urlName:NSURL = NSURL(string: url)!
        let session = NSURLSession.sharedSession()
        let data = NSData(contentsOfURL: NSURL(string: url)!)
        let user = "username=\(NSUserDefaults.standardUserDefaults().valueForKey("USERNAME")!)"
        let queryParam = user.dataUsingEncoding(NSUTF8StringEncoding)
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: urlName)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData

    }
}