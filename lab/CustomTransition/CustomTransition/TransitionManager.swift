//
//  TransitionManager.swift
//  CustomTransition
//
//  Created by Lanston Peng on 7/22/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

import UIKit

class TransitionManager:NSObject, UIViewControllerAnimatedTransitioning {
    
    var isPresent:Bool = true
    
    init(isPresent:Bool)
    {
        self.isPresent = isPresent
        super.init()
    }
   
    func animateTransition(transitionContext: UIViewControllerContextTransitioning!)
    {
        if isPresent
        {
            self.animationForPresentTransition(transitionContext)
        }
        else
        {
            self.animationForDismissTransition(transitionContext)
        }
    }
    func animationForDismissTransition(transitionContext:UIViewControllerContextTransitioning!)
    {
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toViewContrller = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let containerView  = transitionContext.containerView()
        let duration  =  self.transitionDuration(transitionContext)
        
        toViewContrller.view.center.x = fromViewController.view.bounds.size.width/4
        
        UIView.animateWithDuration(duration, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {()->Void in
            
            fromViewController.view.center.x += fromViewController.view.bounds.size.width
            toViewContrller.view.center.x = fromViewController.view.bounds.size.width/2
            
            }, completion: {(completed:Bool) -> Void in
                transitionContext.completeTransition(completed)
            })
    }
    func animationForPresentTransition(transitionContext:UIViewControllerContextTransitioning!)
    {
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toViewContrller = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let containerView  = transitionContext.containerView()
        let duration  =  self.transitionDuration(transitionContext)
        println(fromViewController)
        println(toViewContrller)
        
        toViewContrller.view.center.x += fromViewController.view.bounds.size.width
        
        containerView.addSubview(toViewContrller.view)
        println(transitionContext.initialFrameForViewController(toViewContrller))
        println(transitionContext.finalFrameForViewController(toViewContrller))
        
        UIView.animateWithDuration(duration, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {()->Void in
            
                fromViewController.view.center.x -= fromViewController.view.bounds.size.width/2
                toViewContrller.view.center.x -= fromViewController.view.bounds.size.width
            }, completion: {(completed:Bool) -> Void in
                transitionContext.completeTransition(completed)
            })
        
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning!) -> NSTimeInterval
    {
        return 0.3;
    }
}
