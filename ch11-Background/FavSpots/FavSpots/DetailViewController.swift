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
        let tap = UITapGestureRecognizer(target: self, action: #selector(DetailViewController.dismissKeyboard(_:)))
        view.addGestureRecognizer(tap)
        
        let  g = UITapGestureRecognizer(target: self, action: #selector(DetailViewController.handleNoteTap(_:)))
        noteTextView.addGestureRecognizer(g)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        spot?.name = nameTextField.text
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    //MARK: - gesture method
    func dismissKeyboard(_ gesture:UITapGestureRecognizer){
        nameTextField.resignFirstResponder()
    }
    
    func handleNoteTap(_ gesture:UITapGestureRecognizer){
        performSegue(withIdentifier: "editNote", sender: self)
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
    func roundTo(_ dou:Double)->Double{
        return round(dou*100)/100.0
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        print("\(#function)")
        super.encodeRestorableState(with: coder)
        if spot != nil{
            coder.ptl_encodeSpot(spot!, key: kSpotConstant.spotKey)
        }
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        print("\(#function)")
        super.decodeRestorableState(with: coder)
        spot =  coder.ptl_decodeSpotForKey(kSpotConstant.spotKey)
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editNote" {
            let vc = segue.destination as! TextEditViewController
            vc.spot = spot
        }
    }

}
