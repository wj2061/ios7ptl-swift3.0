//
//  KVCTableViewCell.swift
//  KVC
//
//  Created by wj on 15/11/29.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class KVCTableViewCell: UITableViewCell {
    
    var object : NSObject?{  didSet{ update() } }
    var property : String!{  didSet{ update() } }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func isReady()->Bool{
        return object != nil && property != ""
    }
    
    fileprivate func update(){
        var  text:String?
        if isReady(){
            let value = object!.value(forKeyPath: property)
            text = (value as AnyObject).description
        }
        textLabel!.text = text
    }
    
    init(identifier:String){
        super.init(style: .default, reuseIdentifier: identifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    

}
