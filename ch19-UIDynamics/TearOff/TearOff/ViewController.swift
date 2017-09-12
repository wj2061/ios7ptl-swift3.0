//
//  ViewController.swift
//  TearOff
//
//  Created by wj on 15/11/19.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

let kShapeDimension:CGFloat = 100.0
let kSliceCount:Int = 6

class ViewController: UIViewController {
    
    var animator:UIDynamicAnimator!
    let defaultBehavior = DefaultBehavior()

    override func viewDidLoad() {
        super.viewDidLoad()
        animator = UIDynamicAnimator(referenceView: view)
        
        let frame = CGRect(x: 0, y: 0, width: kShapeDimension, height: kShapeDimension)
        
        let dragView = DraggableView(frame: frame, animator: animator)
        dragView.center = CGPoint(x: view.center.x/4, y: view.center.y/4)
        dragView.alpha = 0.4
        view.addSubview(dragView)
        
        animator.addBehavior(defaultBehavior)
        let tearOffBehavior = TearOffBehavior(view: dragView, anchor: dragView.center) { (tornView, newPinView) -> Void in
            tornView.alpha = 1
            self.defaultBehavior.addItem(tornView)
            let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.trash(_:)))
            tap.numberOfTapsRequired = 2
            tornView.addGestureRecognizer(tap)
        }
        animator.addBehavior(tearOffBehavior)
        
    }
    
    func trash(_ gesture:UITapGestureRecognizer){
        print("trash")
        let gview = gesture.view!
        let subviews = sliceView(gview, rows: 6, columns: 6)
        
        let trashAnimator = UIDynamicAnimator(referenceView: view)
        let dBehaviour = DefaultBehavior()
        for subview in subviews{
            view.addSubview(subview)
            dBehaviour.addItem(subview)
            
            let push = UIPushBehavior(items: [subview], mode: .instantaneous)
            push.pushDirection = CGVector(dx: CGFloat(arc4random())/CGFloat(RAND_MAX) - 0.5, dy: CGFloat(arc4random())/CGFloat(RAND_MAX) - 0.5)
            trashAnimator.addBehavior(push)
            UIView.animate(withDuration: 1, animations: { () -> Void in
                subview.alpha = 0
                }, completion: { (_) -> Void in
                    subview.removeFromSuperview()
                    trashAnimator.removeBehavior(push)
            })
        }
        defaultBehavior.removeItem(gview)
        gview.removeFromSuperview()
    }

    
    func sliceView(_ view:UIView,rows:Int,columns:Int)->[UIView]{
        UIGraphicsBeginImageContext(view.bounds.size)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()?.cgImage
        UIGraphicsEndImageContext()
        
        var views = [UIView]()
        let width = image!.width
        let height = image!.height
        for row in 0..<rows{
            for column in 0..<columns{
                let rect = CGRect(x: CGFloat( column*(width/columns) ),
                                      y: CGFloat( row * (height/rows)),
                                      width: CGFloat(width/columns),
                                      height: CGFloat(height/rows))
                let subImage = image!.cropping(to: rect)
                let imageView = UIImageView(image: UIImage(cgImage: subImage!))
                imageView.frame = rect.offsetBy(dx: view.frame.minX, dy: view.frame.minY)
                views.append(imageView)
            }
        }
        return views
    }
}

