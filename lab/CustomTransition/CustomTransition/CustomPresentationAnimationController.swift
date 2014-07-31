//
//  CustomPresentationAnimationController.swift
//  CustomTransition
//
//  Created by Lanston Peng on 7/16/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

import UIKit

class CustomPresentationAnimationController: NSObject,UIViewControllerAnimatedTransitioning{
    
    let isPresenting :Bool
    
    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
        super.init()
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning!)
    {
        if(self.isPresenting)
        {
            self.animateForPresentTransition(transitionContext)
        }
        else
        {
            self.animateForDismissTransition(transitionContext)
        }
    }
    func animateForDismissTransition(transitionContext:UIViewControllerContextTransitioning!)
    {
        
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let containerView = transitionContext.containerView()
        let duration:NSTimeInterval = self.transitionDuration(transitionContext)
        
        let screenBounds = UIScreen.mainScreen().bounds
        let finalFrame = transitionContext.finalFrameForViewController(fromViewController)
        
        
        //fromViewController.view.frame = CGRectOffset(finalFrame, -screenBounds.size.width, 0)
        //containerView.insertSubview(toViewController.view, aboveSubview: fromViewController.view)
        for v in containerView.subviews
        {
            println(v.tag)
        }
        
        fromViewController.view.frame = transitionContext.initialFrameForViewController(fromViewController)
        
        
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 3, options: UIViewAnimationOptions.CurveLinear, animations: {() -> Void in
            
            fromViewController.view.frame = CGRectOffset(finalFrame, 320, 0)
            //fromViewController.view.frame = CGRectOffset(fromViewController.view.frame, 160, 0);
            
            }, completion: {(completed:Bool) -> Void in
                fromViewController.view.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            })
    }
    
    func animateForPresentTransition(transitionContext:UIViewControllerContextTransitioning!)
    {
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let containerView = transitionContext.containerView()
        let duration:NSTimeInterval = self.transitionDuration(transitionContext)
        
        let screenBounds = UIScreen.mainScreen().bounds
        let finalFrame = transitionContext.finalFrameForViewController(toViewController)
        
        toViewController.view.frame = CGRectOffset(finalFrame, screenBounds.size.width, 0)
        
        containerView.addSubview(toViewController.view)
        
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 3, options: UIViewAnimationOptions.CurveEaseOut, animations: {() -> Void in
            
            toViewController.view.frame = finalFrame
            //fromViewController.view.frame = CGRectOffset(fromViewController.view.frame, -160, 0);
            
            }, completion: {(completed:Bool) -> Void in
                transitionContext.completeTransition(completed)
            })
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning!) -> NSTimeInterval
    {
        return 0.5
    }
}
