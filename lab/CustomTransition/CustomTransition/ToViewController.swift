//
//  ToViewController.swift
//  CustomTransition
//
//  Created by Lanston Peng on 7/22/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

import UIKit

class ToViewController: UIViewController,UIViewControllerTransitioningDelegate{
    
    @IBOutlet var prevBtn: UIButton?
    public var interactSlideTransition:UIPercentDrivenInteractiveTransition?
    public var isByClick:Bool
    
    init(coder aDecoder: NSCoder!)
    {
        self.isByClick = true
        super.init(coder: aDecoder)
    }
   
    func commonInit()
    {
        self.modalPresentationStyle = .Custom
        self.transitioningDelegate = self
    }

    func handleBack(btn:UIButton)
    {
        self.isByClick = true
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func initPic()
    {
        var q = dispatch_queue_create("getimage", nil)
        let screen = UIScreen.mainScreen().bounds
        let url = NSURL(string: "http://lorempixel.com/320/568/")
        var data:NSData?
        var image:UIImage?
        let imageView:UIImageView = UIImageView(frame: screen)
        dispatch_async(q, {
            data = NSData(contentsOfURL: url)
            image = UIImage(data: data)
            dispatch_sync(dispatch_get_main_queue(), {
                imageView.image = image
                imageView.alpha = 0
                self.view.insertSubview(imageView, belowSubview: self.prevBtn!)
                UIView.animateWithDuration(0.3, animations: {()->Void in
                    imageView.alpha = 1
                    })
                })
            })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.clipsToBounds = true
        self.commonInit()
        
        self.initPic()
        
        self.prevBtn!.addTarget(self, action: "handleBack:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let edgeSwipeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "handleEdgePan:")
        edgeSwipeGesture.edges = .Left
        self.view.addGestureRecognizer(edgeSwipeGesture)

        // Do any additional setup after loading the view.
    }
    func handleEdgePan(recognizer:UIScreenEdgePanGestureRecognizer)
    {
        
        var progress:CGFloat  = recognizer.locationInView(self.view.superview).x / (self.view.superview.bounds.size.width * 1.0)
        progress = min(1.0,max(0.0,progress))
        //println("progress \(progress)")
        if recognizer.state == .Began
        {
            self.isByClick = false
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
                self.interactSlideTransition?.finishInteractiveTransition()
            }
            else
            {
                self.interactSlideTransition?.cancelInteractiveTransition()
            }
            self.interactSlideTransition = nil
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning!) -> UIViewControllerInteractiveTransitioning!
    {
        return self.isByClick ? nil :  self.interactSlideTransition
    }
    
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning!) -> UIViewControllerInteractiveTransitioning!
    {
        return self.isByClick ? nil : self.interactSlideTransition
    }

    func animationControllerForPresentedController(presented: UIViewController!, presentingController presenting: UIViewController!, sourceController source: UIViewController!) -> UIViewControllerAnimatedTransitioning!
    {
        if presented == self
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
    
    

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
