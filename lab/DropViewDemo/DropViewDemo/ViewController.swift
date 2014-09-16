//
//  ViewController.swift
//  DropViewDemo
//
//  Created by Lanston Peng on 9/15/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var catView: UIImageView!
    
    var animator:UIDynamicAnimator!
    var attachmentBehaviour:UIAttachmentBehavior!
    var snapBehaviour:UISnapBehavior!
    var pushBehaviour:UIPushBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.animator = UIDynamicAnimator(referenceView: self.view)
        let pan:UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        self.view.addGestureRecognizer(pan)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func handlePanGesture(gesture: UIPanGestureRecognizer) {
        
        let catLocation = gesture.locationInView(catView)
        let location = gesture.locationInView(self.view)
        
        switch(gesture.state)
        {
        case UIGestureRecognizerState.Began:
            
            let centerOffset = UIOffsetMake(catLocation.x - CGRectGetMidX(catView.bounds), catLocation.y - CGRectGetMidY(catView.bounds))
            animator.removeAllBehaviors()
            attachmentBehaviour = UIAttachmentBehavior(item: catView, offsetFromCenter: centerOffset, attachedToAnchor: location)
            animator.addBehavior(attachmentBehaviour)
            break
        case UIGestureRecognizerState.Changed:
            attachmentBehaviour.anchorPoint = gesture.locationInView(self.view)
        case UIGestureRecognizerState.Ended:
            let velocity:CGPoint = gesture.velocityInView(self.view)
            let manitude:CGFloat = sqrt(velocity.x * velocity.x + velocity.y * velocity.y)
            
            if manitude > 1000
            {
                pushBehaviour = UIPushBehavior(items: [catView], mode: UIPushBehaviorMode.Instantaneous)
                pushBehaviour.pushDirection = CGVectorMake(velocity.x/10, velocity.y/10)
                pushBehaviour.magnitude = manitude/35
                animator.addBehavior(pushBehaviour)
            }
            else
            {
                animator.removeBehavior(attachmentBehaviour)
                snapBehaviour = UISnapBehavior(item: catView, snapToPoint: CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds)))
                animator.addBehavior(snapBehaviour)
            }
            
        default:
            break
        }
    }

}

