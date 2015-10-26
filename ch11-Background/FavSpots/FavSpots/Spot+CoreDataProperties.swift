//
//  Spot+CoreDataProperties.swift
//  FavSpots
//
//  Created by wj on 15/10/25.
//  Copyright © 2015年 wj. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Spot {

    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var name: String?
    @NSManaged var notes: String?

}
