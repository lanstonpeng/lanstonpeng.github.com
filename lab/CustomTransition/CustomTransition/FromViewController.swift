//
//  FromViewController.swift
//  CustomTransition
//
//  Created by Lanston Peng on 7/22/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

import UIKit

class FromViewController: UIViewController,UIViewControllerTransitioningDelegate{

    @IBOutlet var nextBtn: UIButton?
    var interactSlideTransition:UIPercentDrivenInteractiveTransition?
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        //self.modalPresentationStyle = .Custom
        //self.transitioningDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let edgeSwipeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "handleTransition:")
        edgeSwipeGesture.edges = .Right
        
        self.nextBtn!.addTarget(self, action: "handleNextButton:", forControlEvents: UIControlEvents.TouchUpInside)
        //self.view.addGestureRecognizer(edgeSwipeGesture)
    }
    
    func handleNextButton(btn:UIButton)
    {
        let toVC = self.storyboard.instantiateViewControllerWithIdentifier("toViewController") as UIViewController
        self.presentViewController(toVC, animated: true, completion: nil)
    }
    
    func handleTransition(recognizer:UIScreenEdgePanGestureRecognizer)
    {
        var progress:CGFloat  = recognizer.locationInView(self.view.superview).x / (self.view.superview.bounds.size.width * 1.0)
        progress = 1.0 - min(1.0,max(0.0,progress))
        //println("progress \(progress)")
        if recognizer.state == .Began
        {
            self.interactSlideTransition = UIPercentDrivenInteractiveTransition()
            let toVC = self.storyboard.instantiateViewControllerWithIdentifier("toViewController") as UIViewController
            toVC.transitioningDelegate = self
            self.presentViewController(toVC, animated: true, completion: nil)
        }
        else if recognizer.state == .Changed
        {
            println("Changed")
            self.interactSlideTransition?.updateInteractiveTransition(progress)
        }
        else if recognizer.state == .Ended || recognizer.state == .Cancelled
        {
            if progress < 0.5
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

    func animationControllerForPresentedController(presented: UIViewController!, presentingController presenting: UIViewController!, sourceController source: UIViewController!) -> UIViewControllerAnimatedTransitioning!
    {
        
        if presenting == self
        {
            return TransitionManager(isPresent: true)
        }
        return nil
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController!) -> UIViewControllerAnimatedTransitioning!
    {
        if dismissed == self
        {
            return TransitionManager(isPresent: false)
        }
        return nil
    }
    
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning!) -> UIViewControllerInteractiveTransitioning!
    {
        if animator.isKindOfClass(TransitionManager.self)
        {
            return self.interactSlideTransition
        }
        return nil
    }
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning!) -> UIViewControllerInteractiveTransitioning!
    {
        return self.interactSlideTransition
    }
    /*
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!)
    {
        if segue.destinationViewController.isKindOfClass(ToViewController.self)
        {
            
        }
    }
*/
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
