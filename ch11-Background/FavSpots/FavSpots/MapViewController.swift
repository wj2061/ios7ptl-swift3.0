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
    fileprivate let manager = CLLocationManager()
    var fetchedResultsController:NSFetchedResultsController<NSFetchRequestResult>?
    
    var managedObjectContext:NSManagedObjectContext?
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined {
            manager.requestWhenInUseAuthorization()
        }
        
        let app = UIApplication.shared.delegate as? AppDelegate
         managedObjectContext = app!.managedObjectContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Spot")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        fetchedResultsController  =  NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController!.delegate = self
        do {
            try  fetchedResultsController?.performFetch()
        }catch{
            print("Unresolved error")
        }
        
        
        mapView.showsUserLocation = true
        let  lpgr = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.handleLongPress(_:)))
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
    
    func handleLongPress(_ gesture:UILongPressGestureRecognizer){
        if gesture.state != UIGestureRecognizerState.began{
            return
        }
        
        let touchPoint = gesture.location(in: mapView)
        let touchMapCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        let spot = Spot.spotWith(touchMapCoordinate, context: managedObjectContext!)
        performSegue(withIdentifier: "newSpot", sender: spot)
    }
    
    //MARK: - MKMapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var an = mapView.dequeueReusableAnnotationView(withIdentifier: MapViewConst.annotationIdentity)
        if an == nil {
            an = MKPinAnnotationView(annotation: annotation, reuseIdentifier: MapViewConst.annotationIdentity)
        }
        an!.canShowCallout = true
        return an!
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
       performSegue(withIdentifier: "newSpot", sender: view.annotation)
        mapView.deselectAnnotation(view.annotation, animated: false)
    }
    

    //MARK : - NSFetchedResultsControllerDelegate
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type{
        case .insert:
            mapView.addAnnotation(anObject as! Spot)
        case .delete:
            mapView.removeAnnotation(anObject as! Spot)
        default:
            break
        }
    }
    

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newSpot"{
            if let sp = sender as? Spot{
                let VC = segue.destination as!DetailViewController
                VC.spot = sp
            }
        }
    }

}
