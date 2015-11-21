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
        return UIPinchGestureRecognizer(target: self, action: "pinch:")
    }()
    
  
    func pinch(gesture:UIPinchGestureRecognizer){
        print("44")

        let scale = gesture.scale
        switch gesture.state{
        case .Began:
            interactionInProgress = true
            startScale = scale
            presentingVC!.proceedToNextViewController()
        case .Changed:
            let completePercent = 1.0 - (scale/startScale)
            updateInteractiveTransition(completePercent)
        case .Ended:
            if gesture.velocity > 0{
                cancelInteractiveTransition()
            }else{
                finishInteractiveTransition()
            }
            interactionInProgress = false
        case .Cancelled:
            cancelInteractiveTransition()
            interactionInProgress = false
        default:
            break
        }
    }

}


