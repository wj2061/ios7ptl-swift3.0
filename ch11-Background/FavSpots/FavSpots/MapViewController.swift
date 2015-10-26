//
//  MapViewController.swift
//  FavSpots
//
//  Created by wj on 15/10/25.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit
import MapKit
import CoreData

struct MapViewConst{
    static let annotationIdentity = "annotation"
}

class MapViewController: UIViewController ,NSFetchedResultsControllerDelegate , MKMapViewDelegate{
    private let manager = CLLocationManager()
    var fetchedResultsController:NSFetchedResultsController?
    
    var managedObjectContext:NSManagedObjectContext?
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined {
            manager.requestWhenInUseAuthorization()
        }
        
        let app = UIApplication.sharedApplication().delegate as? AppDelegate
         managedObjectContext = app!.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Spot")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        fetchedResultsController  =  NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController!.delegate = self
        do {
            try  fetchedResultsController?.performFetch()
        }catch{
            print("Unresolved error")
        }
        
        
        mapView.showsUserLocation = true
        let  lpgr = UILongPressGestureRecognizer(target: self, action: Selector("handleLongPress:"))
        lpgr.minimumPressDuration = 1.5
        mapView.addGestureRecognizer(lpgr)
        mapView.delegate = self
        
        
        if let ss = fetchedResultsController!.fetchedObjects{
            for spot in ss {
                if let sp = spot as? Spot{
                    mapView.addAnnotation(sp)
                }
            }
        }
    }
    
    func handleLongPress(gesture:UILongPressGestureRecognizer){
        if gesture.state != UIGestureRecognizerState.Began{
            return
        }
        
        let touchPoint = gesture.locationInView(mapView)
        let touchMapCoordinate = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
        let spot = Spot.spotWith(touchMapCoordinate, context: managedObjectContext!)
        performSegueWithIdentifier("newSpot", sender: spot)
    }
    
    //MARK: - MKMapViewDelegate
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        var an = mapView.dequeueReusableAnnotationViewWithIdentifier(MapViewConst.annotationIdentity)
        if an == nil {
            an = MKPinAnnotationView(annotation: annotation, reuseIdentifier: MapViewConst.annotationIdentity)
        }
        an!.canShowCallout = true
        return an!
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        
       performSegueWithIdentifier("newSpot", sender: view.annotation)
        mapView.deselectAnnotation(view.annotation, animated: false)
    }
    

    //MARK : - NSFetchedResultsControllerDelegate
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type{
        case .Insert:
            mapView.addAnnotation(anObject as! Spot)
        case .Delete:
            mapView.removeAnnotation(anObject as! Spot)
        default:
            break
        }
    }
    

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "newSpot"{
            if let sp = sender as? Spot{
                let VC = segue.destinationViewController as!DetailViewController
                VC.spot = sp
            }
        }
    }

}
