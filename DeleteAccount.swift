//
//  DeleteAccount.swift
//  logU
//
//  Created by Brett Alcox on 2/15/16.
//  Copyright © 2016 Brett Alcox. All rights reserved.
//

import UIKit
import Foundation

class DeleteAccount {
    
    var url_delete_request: String = "https://loguapp.com/swift_delete.php"
    
    func delete_request(userToDelete: String)
    {
        print(userToDelete)
        let url:NSURL = NSURL(string: url_delete_request)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        let query = "username=\(userToDelete)".dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.uploadTaskWithRequest(request, fromData: query, completionHandler:
            {(data,response,error) in
                
                guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                    print("error")
                    return
                }
                
                let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print(dataString)
            }
        );
        
        task.resume()
        
    }

}
