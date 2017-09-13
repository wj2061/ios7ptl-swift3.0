//
//  SCTPercentDrivenAnimator.swift
//  InteractiveCustomTransitionsDemo
//
//  Created by wj on 15/11/21.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

protocol SCInteractiveTransitionViewControllerDelegate{
    func proceedToNextViewController()
}

extension UIViewController:SCInteractiveTransitionViewControllerDelegate{
    func proceedToNextViewController(){}
}

class SCTPercentDrivenAnimator: UIPercentDrivenInteractiveTransition {
    weak var presentingVC:UIViewController?
    var startScale :CGFloat = 0
    var interactionInProgress = false
    
    
    lazy var gestureRecogniser:UIPinchGestureRecognizer = {
        return UIPinchGestureRecognizer(target: self, action: #selector(SCTPercentDrivenAnimator.pinch(_:)))
    }()
    
  
    func pinch(_ gesture:UIPinchGestureRecognizer){
        print("44")

        let scale = gesture.scale
        switch gesture.state{
        case .began:
            interactionInProgress = true
            startScale = scale
            presentingVC!.proceedToNextViewController()
        case .changed:
            let completePercent = 1.0 - (scale/startScale)
            update(completePercent)
        case .ended:
            if gesture.velocity > 0{
                cancel()
            }else{
                finish()
            }
            interactionInProgress = false
        case .cancelled:
            cancel()
            interactionInProgress = false
        default:
            break
        }
    }

}


