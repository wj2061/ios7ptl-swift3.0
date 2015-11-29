//
//  KVCTableViewCell.swift
//  KVO
//
//  Created by wj on 15/11/29.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class KVCTableViewCell: UITableViewCell {
    var object: NSObject?{
        willSet{
            removeObservation()
        }
        didSet{
            addObservation()
            update()
        }}
    var property: String!{
        willSet{
            removeObservation()
        }
        didSet{
            addObservation()
            update()
        }
    }
    
    func isReady()->Bool{
        return object != nil && property != ""
    }
    
    func update(){
        textLabel?.text = isReady() ? object!.valueForKeyPath(property)?.description : ""
    } 

    func removeObservation(){
        if isReady(){
            object!.removeObserver(self, forKeyPath: property)
        }
    }
    
    func addObservation(){
        if isReady(){
            object?.addObserver(self, forKeyPath:property, options: [], context: UnsafeMutablePointer(Unmanaged.passUnretained(self).toOpaque()))
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        let ct = Unmanaged<KVCTableViewCell>.fromOpaque(COpaquePointer(context)).takeUnretainedValue()
        if ct == self{
            update()
        }else{
            super.observeValueForKeyPath(keyPath, ofObject: object , change: change, context: context)
        }
    }
    
    deinit{
        removeObservation()
    }
}
