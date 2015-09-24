//
//  MKDetailsViewController.swift
//  CollectionViewDemo
//
//  Created by wj on 15/9/25.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class MKDetailsViewController: UIViewController {
    var  photoPath:String?{didSet{updateUI()}}
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var textLabel: UILabel!

    @IBAction func doneTapped() {
        dismissViewControllerAnimated(true , completion: nil)
    }
    
    func updateUI(){
        if let  path = photoPath{
            let component=NSString(string: path).lastPathComponent
            textLabel?.text=NSString(string: component).stringByDeletingPathExtension
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), { () -> Void in
                let  image = UIImage(contentsOfFile: path)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.imageView?.image=image
                })
            })
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }


    
    override func shouldAutorotate() -> Bool {
      return true
    }


}
