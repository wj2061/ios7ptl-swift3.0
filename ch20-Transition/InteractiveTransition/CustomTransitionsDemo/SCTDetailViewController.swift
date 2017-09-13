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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scPercent?.presentingVC = self
    }
    
    var detailItem:Date?{
        didSet{
            configureView()
        }
    }
    
    @IBAction func colseButtonTapped(_ sender: UIButton) {
        dismiss(animated: true , completion: nil)
    }
 
    func configureView(){
        if let  date = detailItem{
            dateLabel?.text = date.description
        }
    }
    
    override func proceedToNextViewController() {
        dismiss(animated: true , completion: nil)
    }
    
    var scPercent:SCTPercentDrivenAnimator?

}
