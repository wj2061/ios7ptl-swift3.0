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
        dismiss(animated: true , completion: nil)
    }
    
    func updateUI(){
        if let  path = photoPath{
            let component=NSString(string: path).lastPathComponent
            textLabel?.text=NSString(string: component).deletingPathExtension
            
            DispatchQueue.global(qos: .userInitiated).async(execute: { () -> Void in
                let  image = UIImage(contentsOfFile: path)
                DispatchQueue.main.async(execute: { () -> Void in
                    self.imageView?.image=image
                })
            })
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }


    
    override var shouldAutorotate : Bool {
      return true
    }


}
