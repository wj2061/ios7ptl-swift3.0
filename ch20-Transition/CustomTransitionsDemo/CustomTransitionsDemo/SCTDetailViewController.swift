//
//  SCTDetailViewController.swift
//  CustomTransitionsDemo
//
//  Created by wj on 15/11/21.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class SCTDetailViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    var detailItem:NSDate?{
        didSet{
            configureView()
        }
    }
    
    @IBAction func colseButtonTapped(sender: UIButton) {
        dismissViewControllerAnimated(true , completion: nil)
    }
 
    func configureView(){
        if let  date = detailItem{
            dateLabel?.text = date.description
        }
    }

}
