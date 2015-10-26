//
//  Spot+nscoder.swift
//  FavSpots
//
//  Created by wj on 15/10/26.
//  Copyright © 2015年 wj. All rights reserved.
//

import Foundation
import UIKit

extension NSCoder{
    func ptl_encodeSpot(spot:Spot,key:String){
        let spotID = spot.objectID
        encodeObject(spotID.URIRepresentation(), forKey: key)
    }
    
    func ptl_decodeSpotForKey(key:String)->Spot?{
        var spot:Spot? = nil
        if let spotURI = decodeObjectForKey(key)  as? NSURL{
            let app = UIApplication.sharedApplication().delegate as? AppDelegate
            let context = app!.managedObjectContext
            
            if   let  spotID = context.persistentStoreCoordinator?.managedObjectIDForURIRepresentation(spotURI){
                spot = context.objectWithID(spotID) as? Spot
            }
        }
        return spot
    }
    
}
