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
    func ptl_encodeSpot(_ spot:Spot,key:String){
        let spotID = spot.objectID
        encode(spotID.uriRepresentation(), forKey: key)
    }
    
    func ptl_decodeSpotForKey(_ key:String)->Spot?{
        var spot:Spot? = nil
        if let spotURI = decodeObject(forKey: key)  as? URL{
            let app = UIApplication.shared.delegate as? AppDelegate
            let context = app!.managedObjectContext
            
            if   let  spotID = context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: spotURI){
                spot = context.object(with: spotID) as? Spot
            }
        }
        return spot
    }
    
}
