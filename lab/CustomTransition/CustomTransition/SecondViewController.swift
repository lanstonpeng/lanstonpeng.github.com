//
//  SecondViewController.swift
//  CustomTransition
//
//  Created by Lanston Peng on 7/9/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

import UIKit
class SecondViewController: UIViewController,UINavigationControllerDelegate {
    @IBOutlet var back: UIButton
    var interactPopTransition:UIPercentDrivenInteractiveTransition?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.orangeColor()
        back.addTarget(self, action: "handleBack:",forControlEvents:.TouchUpInside)
        
        let swipeRightRecognizer:UIScreenEdgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: "handleSwipeRight:")
        swipeRightRecognizer.edges = .Left
        self.view.addGestureRecognizer(swipeRightRecognizer)
    }
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        self.navigationController.delegate = self
    }
    override  func viewWillDisappear(animated: Bool)
    {
        if self.conformsToProtocol(UINavigationControllerDelegate)
        {
           self.navigationController.delegate = nil
        }
    }
    func handleBack(sender:UIButton) -> Void
    {
        self.navigationController.popToRootViewControllerAnimated(true)
    }
    
    func navigationController(navigationController: UINavigationController!, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController!, toViewController toVC: UIViewController!) -> UIViewControllerAnimatedTransitioning!
    {
        if(fromVC == self && toVC.isKindOfClass(FirstViewController.self))
        {
            return TransitionFromSecondToFirst()
        }
        return nil
    }
    
    func navigationController(navigationController: UINavigationController!, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning!) -> UIViewControllerInteractiveTransitioning!
    {
        if(animationController.isKindOfClass(TransitionFromSecondToFirst.self))
        {
            return self.interactPopTransition
        }
        return nil
    }
    func handleSwipeRight(recognizer:UIScreenEdgePanGestureRecognizer) -> Void
    {
        var progress:CGFloat = recognizer.translationInView(self.view.superview).x / (self.view.superview.bounds.size.width * 1.0);
        println("translate \(recognizer.translationInView(self.view.superview).x)")
        progress = min(1.0, max(0.0, progress));
        println("progress \(progress)")
        if recognizer.state == .Began
        {
            println("began")
            self.interactPopTransition = UIPercentDrivenInteractiveTransition()
            self.navigationController.popViewControllerAnimated(true)
        }
        else if(recognizer.state == .Changed)
        {
            println("changed")
            self.interactPopTransition?.updateInteractiveTransition(progress)
        }
        else if(recognizer.state == .Ended || recognizer.state == .Cancelled)
        {
            println("finsih")
            if (progress > 0.5) {
                self.interactPopTransition?.finishInteractiveTransition()
            }
            else {
                self.interactPopTransition?.cancelInteractiveTransition()
            }
            
            self.interactPopTransition = nil
        }
    }
}
