//
//  MovieTableViewController.swift
//  My Movie
//
//  Created by Andi Setiyadi on 12/16/15.
//  Copyright © 2015 PFI. All rights reserved.
//

import UIKit
import CoreData

class MovieTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var coreData = CoreData()
    
    var fetchedResultsController: NSFetchedResultsController!
    var managedObjectContext: NSManagedObjectContext!
    var movieToDelete: Movie?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: - Helpers
    
    func loadData() {
        
        managedObjectContext = coreData.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Movie")
        let sort = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sort]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetched results controller failed to perform the fetch")
        }
        
    }
    
}

extension MovieTableViewController {
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        
        return 0
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = fetchedResultsController.sections {
            
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        
        return 0
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("movieCell", forIndexPath: indexPath) as! MovieTableViewCell
        
        let movie = fetchedResultsController.objectAtIndexPath(indexPath) as! Movie
        
        cell.movieNameLabel.text = movie.name
        cell.movieFormatLabel.text = movie.format
        cell.userRating.rating = (movie.userRating?.integerValue)!
        cell.movieImageView.image = UIImage(data: movie.image!)
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            movieToDelete = fetchedResultsController.objectAtIndexPath(indexPath) as? Movie
            
            let confirmDeleteAlertController = UIAlertController(title: "Remove Movie", message: "The movie \"\(movieToDelete!.name)\" will be removed from your library.  Are you sure you want to proceed?", preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            let deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default) { (action) in
                
                self.managedObjectContext.deleteObject(self.movieToDelete!)
                self.coreData.saveContext()
                self.movieToDelete = nil
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (action) in
                
                self.movieToDelete = nil
                
            }
            
            confirmDeleteAlertController.addAction(deleteAction)
            confirmDeleteAlertController.addAction(cancelAction)
            
            presentViewController(confirmDeleteAlertController, animated: true, completion: nil)
            
            
            // Delete the row from the data source
            // tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade) *** NSFetchedResultsController will be used instead
            
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
}


extension MovieTableViewController: NSFetchedResultsControllerDelegate {
    
    // MARK: - Delegate methods
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        /* Detect the type of change that has triggered the event */
        
        switch type {
            
        case NSFetchedResultsChangeType.Delete:
            
            print("NSFetchedResultsChangeType.Delete detected")
            
            if let deleteIndexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([deleteIndexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            }
            
        case NSFetchedResultsChangeType.Insert:
            print("NSFetchedResultsChangeType.Delete detected")
        case NSFetchedResultsChangeType.Move:
            print("NSFetchedResultsChangeType.Delete detected")
        case NSFetchedResultsChangeType.Update:
            print("NSFetchedResultsChangeType.Delete detected")
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    
    
}
