//
//  RootViewController.swift
//  KVC-Collection
//
//  Created by wj on 15/11/29.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var entryLabel: UILabel!
    
    var array = TimesTwoArray()
    
    @IBAction func performAdd(sender: UIButton) {
        array.incrementCount()
        refresh()
    }

    func refresh(){
        let items = array.valueForKey("numbers")
        let count = items!.count
        countLabel.text = "\(count)"
        entryLabel.text = items!.lastObject??.description
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       let VC = segue.destinationViewController as! KVCTableViewController
        VC.array = array
    }
}
