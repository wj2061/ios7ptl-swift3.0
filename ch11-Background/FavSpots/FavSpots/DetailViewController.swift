//
//  DetailViewController.swift
//  FavSpots
//
//  Created by wj on 15/10/26.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {
    
    var spot : Spot?{didSet{ updateUI() } }
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var noteTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard:"))
        view.addGestureRecognizer(tap)
        
        let  g = UITapGestureRecognizer(target: self, action: Selector("handleNoteTap:"))
        noteTextView.addGestureRecognizer(g)

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        spot?.name = nameTextField.text
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    //MARK: - gesture method
    func dismissKeyboard(gesture:UITapGestureRecognizer){
        nameTextField.resignFirstResponder()
    }
    
    func handleNoteTap(gesture:UITapGestureRecognizer){
        performSegueWithIdentifier("editNote", sender: self)
    }
    
    func updateUI(){
        mapView?.removeAnnotations(mapView.annotations)
        if let sp = spot {
            mapView?.addAnnotation(sp)
            mapView?.showAnnotations([sp], animated: true)
        }
        nameTextField?.text = spot?.name
        noteTextView?.text = spot?.notes
        locationLabel?.text = "(\(roundTo(( spot?.latitude ?? 0).doubleValue) ),\( roundTo(( spot?.longitude ?? 0).doubleValue)))"
    }
    
    
    //MARK:- Unitily
    func roundTo(dou:Double)->Double{
        return round(dou*100)/100.0
    }
    
    override func encodeRestorableStateWithCoder(coder: NSCoder) {
        print("\(__FUNCTION__)")
        super.encodeRestorableStateWithCoder(coder)
        if spot != nil{
            coder.ptl_encodeSpot(spot!, key: kSpotConstant.spotKey)
        }
    }
    
    override func decodeRestorableStateWithCoder(coder: NSCoder) {
        print("\(__FUNCTION__)")
        super.decodeRestorableStateWithCoder(coder)
        spot =  coder.ptl_decodeSpotForKey(kSpotConstant.spotKey)
    }
    
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editNote" {
            let vc = segue.destinationViewController as! TextEditViewController
            vc.spot = spot
        }
    }

}
