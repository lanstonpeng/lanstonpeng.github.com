//
//  PresentaionViewController.swift
//  CustomTransition
//
//  Created by Lanston Peng on 7/16/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

import UIKit

class PresentaionViewController: UIViewController,UIViewControllerTransitioningDelegate {

    @IBOutlet var showText: UILabel?
    @IBOutlet var backBtn: UIButton?
    var interactSlideTransition:UIPercentDrivenInteractiveTransition?
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        self.modalPresentationStyle = .Custom
        self.transitioningDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let edgeSwipeGesture  = UIScreenEdgePanGestureRecognizer(target: self, action: "handleEdgeSwipeRight:")
        edgeSwipeGesture.edges = .Left
        self.backBtn!.addTarget(self, action: "handleBack:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addGestureRecognizer(edgeSwipeGesture)
    }
    func handleBack(sender:UIButton)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func handleEdgeSwipeRight(recognizer:UIScreenEdgePanGestureRecognizer)
    {
        var progress:CGFloat  = recognizer.locationInView(self.view.superview).x / (self.view.superview.bounds.size.width * 1.0)
        progress = min(1.0,max(0.0,progress))
        //println("progress \(progress)")
        if recognizer.state == .Began
        {
            self.interactSlideTransition = UIPercentDrivenInteractiveTransition()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        else if recognizer.state == .Changed
        {
            self.interactSlideTransition?.updateInteractiveTransition(progress)
        }
        else if recognizer.state == .Ended || recognizer.state == .Cancelled
        {
            if progress > 0.5
            {
                println("finished")
                self.interactSlideTransition?.finishInteractiveTransition()
            }
            else
            {
                println("canceled")
                self.interactSlideTransition?.cancelInteractiveTransition()
            }
            self.interactSlideTransition = nil
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func presentationControllerForPresentedViewController(presented: UIViewController!, presentingViewController presenting: UIViewController!, sourceViewController source: UIViewController!) -> UIPresentationController!
    {
        if presented == self
        {
            return CustomPresentaionController(presentedViewController: self,presentingViewController: presenting)
            
        }
        return nil
    }
    
    func animationControllerForPresentedController(presented: UIViewController!, presentingController presenting: UIViewController!, sourceController source: UIViewController!) -> UIViewControllerAnimatedTransitioning!
    {
        if presented == self
        {
            return CustomPresentationAnimationController(isPresenting: true)
        }
        return nil
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController!) -> UIViewControllerAnimatedTransitioning!
    {
        if dismissed == self
        {
            return CustomPresentationAnimationController(isPresenting: false)
        }
        return nil
    }
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning!) -> UIViewControllerInteractiveTransitioning!
    {
        if animator.isKindOfClass(CustomPresentationAnimationController.self)
        {
            return self.interactSlideTransition
        }
        return nil
    }
    
    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
