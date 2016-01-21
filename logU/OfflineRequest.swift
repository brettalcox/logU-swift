//
//  OfflineRequest.swift
//  logU
//
//  Created by Brett on 1/21/16.
//  Copyright © 2016 Brett Alcox. All rights reserved.
//

import Foundation
import UIKit
import CoreData

var lifting = [NSManagedObject]()
let url_to_post:String = "https://loguapp.com/swift2.php"

class OfflineRequest {
    
    class func coreDataInsert(date: String, lift: String, sets: String, reps: String, weight: String) {
        
        //if Reachability.isConnectedToNetwork() {
        //    print("butts")
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            let entity = NSEntityDescription.entityForName("Insert", inManagedObjectContext: managedContext)
            let insert = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        insert.setValue(NSUserDefaults.standardUserDefaults().valueForKey("USERNAME")!, forKey: "username")
            insert.setValue(lift, forKey: "lift")
            insert.setValue(date, forKey: "date")
            insert.setValue(sets, forKey: "sets")
            insert.setValue(reps, forKey: "reps")
            insert.setValue(weight, forKey: "weight")
            
            do {
                try managedContext.save()
                lifting.append(insert)
            } catch let error as NSError {
                print("Could not save")
            }
            
        }
    
    func OfflineFetchSubmit() {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Insert")
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            lifting = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch")
        }
        
        for i in 0..<lifting.count {
            print(lifting[i].valueForKey("date")!)
            print(lifting[i].valueForKey("lift")!)
            print(lifting[i].valueForKey("sets")!)
            print(lifting[i].valueForKey("reps")!)
            print(lifting[i].valueForKey("weight")!)
        }

        if lifting.count != 0 {
        
        let url:NSURL = NSURL(string: url_to_post)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        for i in 0..<lifting.count {
            

        let query = "name=\(NSUserDefaults.standardUserDefaults().valueForKey("USERNAME")!)&date=\(lifting[i].valueForKey("date")!)&lift=\(lifting[i].valueForKey("lift")!)&sets=\(lifting[i].valueForKey("sets")!)&reps=\(lifting[i].valueForKey("reps")!)&weight=\(lifting[i].valueForKey("weight")!)".dataUsingEncoding(NSUTF8StringEncoding)
        
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
        
        let predicate = NSPredicate(format: "username == %@", "\(NSUserDefaults.standardUserDefaults().valueForKey("USERNAME")!)")
        let deleteFetchRequest = NSFetchRequest(entityName: "Insert")
        deleteFetchRequest.predicate = predicate
        
        do {
            let fetchedEntities = try managedContext.executeFetchRequest(deleteFetchRequest)
            for entity in fetchedEntities {
                managedContext.deleteObject(entity as! NSManagedObject)
            }
        } catch {
            
        }
        do {
            try managedContext.save()
        } catch {
            
        }
        }
        
    }
    
    func OfflineFetch() -> [NSManagedObject]{
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Insert")
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            lifting = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch")
        }
        
        return lifting
    }


    //}
}