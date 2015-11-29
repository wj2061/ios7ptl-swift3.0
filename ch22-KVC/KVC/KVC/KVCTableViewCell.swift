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

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func isReady()->Bool{
        return object != nil && property != ""
    }
    
    private func update(){
        var  text:String?
        if isReady(){
            let value = object!.valueForKeyPath(property)
            text = value?.description
        }
        textLabel!.text = text
    }
    
    init(identifier:String){
        super.init(style: .Default, reuseIdentifier: identifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    

}
