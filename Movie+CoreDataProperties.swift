//
//  Movie+CoreDataProperties.swift
//  My Movie
//
//  Created by Andi Setiyadi on 12/16/15.
//  Copyright © 2015 PFI. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Movie {

    @NSManaged var name: String?
    @NSManaged var userRating: NSNumber?
    @NSManaged var image: NSData?
    @NSManaged var format: String?

}
