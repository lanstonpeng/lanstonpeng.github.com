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
    func printPaperControllerView(containerView:UIView)
    {
        for view in containerView.subviews
        {
            println(view.tag)
        }
    }
    func animationForDismissTransition(transitionContext:UIViewControllerContextTransitioning!)
    {
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toViewContrller = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let containerView  = transitionContext.containerView()
        let duration  =  self.transitionDuration(transitionContext)
        
        
        let screenBounds = UIScreen.mainScreen().bounds
        let finalFrame = transitionContext.finalFrameForViewController(toViewContrller)
        
        toViewContrller.view.frame =  CGRectOffset(finalFrame,-screenBounds.size.width,0)
        self.printPaperControllerView(containerView)
        containerView.insertSubview(toViewContrller.view, aboveSubview: fromViewController.view)
        self.printPaperControllerView(containerView)
        
        UIView.animateWithDuration(duration, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {()->Void in
            
            toViewContrller.view.frame = finalFrame
            fromViewController.view.frame =  CGRectOffset(fromViewController.view.frame, 160, 0);
            
            }, completion: {(completed:Bool) -> Void in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            })
    }
    func animationForPresentTransition(transitionContext:UIViewControllerContextTransitioning!)
    {
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toViewContrller = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let containerView  = transitionContext.containerView()
        
        let duration  =  self.transitionDuration(transitionContext)
        
        let screenBounds = UIScreen.mainScreen().bounds
        let finalFrame = transitionContext.finalFrameForViewController(toViewContrller)
        
        toViewContrller.view.frame = CGRectOffset(finalFrame,screenBounds.size.width,0)
        
        containerView.addSubview(toViewContrller.view)
        self.printPaperControllerView(containerView)    
        
        UIView.animateWithDuration(duration, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {()->Void in
            
            toViewContrller.view.frame = finalFrame
            fromViewController.view.frame =  CGRectOffset(fromViewController.view.frame, -160, 0);
            
            }, completion: {(completed:Bool) -> Void in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            })
        
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning!) -> NSTimeInterval
    {
        return 0.5;
    }
}
