//
//  KVCTableViewCell.swift
//  KVO
//
//  Created by wj on 15/11/29.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class KVCTableViewCell: UITableViewCell {
    private static var myContext = 0
    
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
        textLabel?.text = isReady() ? (object!.value(forKeyPath: property) as AnyObject).description : ""
    } 

    func removeObservation(){
        if isReady(){
            object!.removeObserver(self, forKeyPath: property)
        }
    }
    
    func addObservation(){
        if isReady(){
            object?.addObserver(self, forKeyPath:property, options: [], context: &KVCTableViewCell.myContext)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &KVCTableViewCell.myContext{
            update()
        }else{
            super.observeValue(forKeyPath: keyPath, of: object , change: change, context: context)
        }
    }
    
    deinit{
        removeObservation()
    }
}
