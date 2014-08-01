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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let edgeSwipeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "handleTransition:")
        edgeSwipeGesture.edges = .Right
        self.view.clipsToBounds = true
        self.view.tag = 1
        self.nextBtn!.addTarget(self, action: "handleNextButton:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addGestureRecognizer(edgeSwipeGesture)
    }
    
    func handleNextButton(btn:UIButton)
    {
        let toVC = self.storyboard.instantiateViewControllerWithIdentifier("toViewController") as ToViewController
        toVC.isByClick = true
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
            let toVC = self.storyboard.instantiateViewControllerWithIdentifier("toViewController") as ToViewController
            toVC.isByClick = false
            toVC.interactSlideTransition = self.interactSlideTransition
            
            self.presentViewController(toVC, animated: true, completion: nil)
            
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
    


}
