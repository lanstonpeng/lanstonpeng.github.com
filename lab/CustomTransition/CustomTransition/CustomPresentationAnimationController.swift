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
        let presentedControllerView = transitionContext.viewForKey(UITransitionContextFromViewKey)
        let presentingControllerView = transitionContext.viewForKey(UITransitionContextToViewKey)
        let containerView = transitionContext.containerView()
        
        let duration:NSTimeInterval = self.transitionDuration(transitionContext)
        
        containerView.insertSubview(presentedControllerView, belowSubview: presentingControllerView)
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 3, options: UIViewAnimationOptions.CurveLinear, animations: {() -> Void in
                presentedControllerView.center.x += containerView.bounds.size.width;
            }, completion: {(completed:Bool) -> Void in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                println(presentedControllerView.frame)
            })
    }
    
    func animateForPresentTransition(transitionContext:UIViewControllerContextTransitioning!)
    {
        let presentedController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let presentedControllerView = transitionContext.viewForKey(UITransitionContextToViewKey)
        let containerView = transitionContext.containerView()
        let duration:NSTimeInterval = self.transitionDuration(transitionContext)
        
        presentedControllerView.frame = transitionContext.finalFrameForViewController(presentedController)
        presentedControllerView.center.x += containerView.bounds.size.width
        
        containerView.addSubview(presentedControllerView)
        
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 3, options: UIViewAnimationOptions.CurveEaseOut, animations: {() -> Void in
                presentedControllerView.center.x -= containerView.bounds.size.width
            }, completion: {(completed:Bool) -> Void in
                transitionContext.completeTransition(completed)
                println(presentedControllerView.frame)
            })
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning!) -> NSTimeInterval
    {
        return 0.5
    }
}
