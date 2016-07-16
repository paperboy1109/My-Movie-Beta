//
//  AppDelegate.swift
//  My Movie
//
//  Created by Andi Setiyadi on 12/16/15.
//  Copyright © 2015 PFI. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        checkDataStore()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func checkDataStore() {
        
        print("Checking the data store ... ")
        
        let coreData = CoreData()
        let request = NSFetchRequest(entityName: "Movie")
        
        // let movieCount = coreData.managedObjectContext.countForFetchRequest(request, error: NSErrorPointer.init())
        let movieCount = coreData.managedObjectContext.countForFetchRequest(request, error: nil)
        print("Total movies: \(movieCount)")
        
        if movieCount == 0 {
            uploadSampleData()
        }
    }
    
    func uploadSampleData() {
        let coreData = CoreData()
        
        let url = NSBundle.mainBundle().URLForResource("movies", withExtension: "json")
        let data = NSData(contentsOfURL: url!)
        
        do {
            let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            let jsonArray = jsonResult.valueForKey("movie") as! NSArray
            
            for json in jsonArray {
                let movie = NSEntityDescription.insertNewObjectForEntityForName("Movie", inManagedObjectContext: coreData.managedObjectContext) as! Movie
                
                movie.name = json["name"] as? String
                movie.userRating = json["rating"] as? NSNumber
                movie.format = json["format"] as? String
                
                let imageName = json["image"] as? String
                let image = UIImage(named: imageName!)
                let imageData = UIImagePNGRepresentation(image!)
                
                movie.image = imageData
            }
            
            coreData.saveContext()
            
            let request = NSFetchRequest(entityName: "Movie")
            // let movieCount = coreData.managedObjectContext.countForFetchRequest(request, error: NSErrorPointer.init())
            let movieCount = coreData.managedObjectContext.countForFetchRequest(request, error: nil)
            print("Total movie: \(movieCount)")
        }
        catch {
            fatalError("Cannot upload sample data")
        }
    }
}

