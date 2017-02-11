//
//  Spot.swift
//  FavSpots
//
//  Created by wj on 15/10/25.
//  Copyright © 2015年 wj. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation
import MapKit

class Spot: NSManagedObject , MKAnnotation {
    
    class func spotWith(_ coordinate:CLLocationCoordinate2D,context:NSManagedObjectContext )->Spot {
        let sp = NSEntityDescription.insertNewObject(forEntityName: "Spot", into: context) as! Spot
        
        let df =  DateFormatter()
        df.dateStyle  = DateFormatter.Style.short
        df.timeStyle  = DateFormatter.Style.short
        
        sp.name = "New Spot \(df.string(from: Date()))"
        sp.longitude = NSNumber(value:coordinate.longitude)
        sp.latitude  = NSNumber(value:coordinate.latitude)
        return sp
    }
    
    var coordinate :CLLocationCoordinate2D{
        get{
            return CLLocationCoordinate2D(latitude: latitude.doubleValue , longitude: longitude.doubleValue)
        }
    }
    
    var title :String?{
        return name
    }
// Insert code here to add functionality to your managed object subclass

}
