//
//  CustomPresentaionController.swift
//  CustomTransition
//
//  Created by Lanston Peng on 7/16/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

import UIKit

class CustomPresentaionController: UIPresentationController {
    lazy var chromeView:UIView = {
        let view = UIView(frame: self.containerView!.bounds)
        view.backgroundColor = UIColor.grayColor()
        view.alpha = 0.0
        return view
    }()
    
    override func presentationTransitionWillBegin()
    {
        self.containerView.addSubview(self.chromeView)
        self.containerView.addSubview(self.presentedView())
        
        // Fade in the dimming view alongside the transition
        let transitionCoordinator = self.presentingViewController.transitionCoordinator()
        transitionCoordinator.animateAlongsideTransition({(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
            self.chromeView.alpha  = 0.6
            }, completion:nil)
    }
    
    override func presentationTransitionDidEnd(completed: Bool)
    {
        if !completed
        {
            self.chromeView.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin()
    {
        let transitionCoordinator = self.presentingViewController.transitionCoordinator()
        transitionCoordinator.animateAlongsideTransition({(context:UIViewControllerTransitionCoordinatorContext!) -> Void in
            self.chromeView.alpha = 0.2;
            }, completion: nil)
    }
    override func dismissalTransitionDidEnd(completed: Bool)
    {
        if completed {
            self.chromeView.removeFromSuperview()
        }
    }
    
    
    
    override func frameOfPresentedViewInContainerView() -> CGRect {
        // We don't want the presented view to fill the whole container view, so inset it's frame
        var frame = self.containerView.bounds;
        frame = CGRectInset(frame, 0 , 100.0)
        return frame
    }

}
