//
//  DSLTransitionFromFirstToSecond.swift
//  CustomTransition
//
//  Created by Lanston Peng on 7/9/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

import Foundation
import UIKit

class TransitionFromFirstToSecond:NSObject,UIViewControllerAnimatedTransitioning
{
    func animateTransition(transitionContext: UIViewControllerContextTransitioning!)
    {
        let firstVC:FirstViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as FirstViewController
        let secondVC:SecondViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as SecondViewController
        let containerView:UIView = transitionContext.containerView()
        
        let duration:NSTimeInterval = self.transitionDuration(transitionContext)
        let originalFrame = secondVC.view.frame
        secondVC.view.transform = CGAffineTransformMakeScale(0, 0)
        secondVC.view.center = firstVC.view.center
        secondVC.view.alpha = 0;
        containerView.addSubview(secondVC.view)
        UIView.animateWithDuration(duration, delay: 0,
                            usingSpringWithDamping: 0.6,
                            initialSpringVelocity : 1,
                            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {()->Void in
                secondVC.view.transform = CGAffineTransformMakeScale(1, 1)
                secondVC.view.alpha = 1;
            }, completion: {(Bool) -> Void in
                println("first to second finished")
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            })
        
    }
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning!) -> NSTimeInterval
    {
        return 0.3;
    }
}
