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
    
    class func spotWith(coordinate:CLLocationCoordinate2D,context:NSManagedObjectContext )->Spot {
        let sp = NSEntityDescription.insertNewObjectForEntityForName("Spot", inManagedObjectContext: context) as! Spot
        
        let df =  NSDateFormatter()
        df.dateStyle  = NSDateFormatterStyle.ShortStyle
        df.timeStyle  = NSDateFormatterStyle.ShortStyle
        
        sp.name = "New Spot \(df.stringFromDate(NSDate()))"
        sp.longitude = coordinate.longitude
        sp.latitude  = coordinate.latitude 
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
