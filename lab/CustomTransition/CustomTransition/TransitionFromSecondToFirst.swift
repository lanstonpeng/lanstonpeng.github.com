//
//  TransitionFromSecondToFirst.swift
//  CustomTransition
//
//  Created by Lanston Peng on 7/10/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

import Foundation
import UIKit

class TransitionFromSecondToFirst:NSObject,UIViewControllerAnimatedTransitioning
{
    func animateTransition(transitionContext: UIViewControllerContextTransitioning!)
    {
        let firstVC:FirstViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as FirstViewController
        let secondVC:SecondViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as SecondViewController
        let containerView:UIView = transitionContext.containerView()
        
        let duration:NSTimeInterval = self.transitionDuration(transitionContext)
        
        let originalFrame = secondVC.view.frame
        secondVC.view.transform = CGAffineTransformMakeScale(1, 1)
        firstVC.view.center = firstVC.view.center
        containerView.insertSubview(firstVC.view, belowSubview: secondVC.view)
        //println(containerView.subviews)
        UIView.animateWithDuration(duration, delay: 0,
                            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {()->Void in
                secondVC.view.transform = CGAffineTransformMakeScale(0.01, 0.01)
            }, completion: {(Bool) -> Void in
                println("second to first finished")
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            })
        
    }
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning!) -> NSTimeInterval
    {
        return 0.3;
    }
}