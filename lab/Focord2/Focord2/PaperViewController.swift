//
//  PaperViewController.swift
//  CustomTransition
//
//  Created by Lanston Peng on 7/31/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

import UIKit
import QuartzCore

class PaperViewController: UIViewController ,UIViewControllerTransitioningDelegate{

    public var interactSlideTransition:UIPercentDrivenInteractiveTransition?
    
    //TODO
    public var pageCount = 5
    public var currentIndex = 0
    
    var hasNextRecord:Bool = true
    var verticalLine:CAShapeLayer?
    
    func generateRandomColor() -> UIColor
    {
        let num = arc4random() % 4
        switch num
        {
        case 1:
            return UIColor.redColor()
        case 2:
            return UIColor.orangeColor()
        case 3:
            return UIColor.blueColor()
        case 4:
            return UIColor.greenColor()
        default:
            return UIColor.yellowColor()
        }
    }
    
    func initViewDecoration()
    {
        let layer = self.view.layer
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 10
        layer.shadowOffset = CGSizeMake(2, 2)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createLine()
        //    NSString* levelPath = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"];
        //    _levelConfig = [NSArray arrayWithContentsOfFile:levelPath];
        self.modalPresentationStyle = .Custom
        self.transitioningDelegate = self
        
        self.view.clipsToBounds = true
        println(self.view)
        let edgeSwipeGestureRight = UIScreenEdgePanGestureRecognizer(target: self, action: "handleTransitionRight:")
        edgeSwipeGestureRight.edges = .Right
        
        self.view.addGestureRecognizer(edgeSwipeGestureRight)
        
        self.view.backgroundColor = self.generateRandomColor()
        
        self.initViewDecoration()
        
        let edgeSwipeGestureLeft = UIScreenEdgePanGestureRecognizer(target: self, action: "handleTransitionLeft:")
        edgeSwipeGestureLeft.edges = .Left
        self.view.addGestureRecognizer(edgeSwipeGestureLeft)
        
        let pullDownSwipe = UIPanGestureRecognizer(target: self, action: "handlePullDown:")
        self.view.addGestureRecognizer(pullDownSwipe)
        
        //self.initPic()
        
    }
    
    func handlePullDown(recoginzer:UIPanGestureRecognizer)
    {
        let deltaY:CGFloat = recoginzer.translationInView(self.view).y
        if(deltaY > 0)
        {
            if(deltaY < 170)
            {
                verticalLine!.path = self.getLinePathWithAmount(deltaY)
                
                if recoginzer.state == UIGestureRecognizerState.Ended
                {
                    self.animateLine(deltaY)
                }
            }
            else
            {
                self.animateLine(deltaY)
            }
        }
    }
    func animateLine(PositionY:CGFloat)
    {
        let keyFA = CAKeyframeAnimation(keyPath: "path")
        keyFA.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        let values:NSArray = [
            self.getLinePathWithAmount(PositionY),
            self.getLinePathWithAmount(-PositionY * 0.9),
            self.getLinePathWithAmount(PositionY * 0.6),
            self.getLinePathWithAmount(-PositionY * 0.4),
            self.getLinePathWithAmount(PositionY * 0.25),
            self.getLinePathWithAmount(PositionY * 0)
        ]
        keyFA.values = values
        keyFA.duration = 0.6
        keyFA.removedOnCompletion = false
        keyFA.fillMode = kCAFillModeForwards
        keyFA.delegate = self
        verticalLine?.addAnimation(keyFA, forKey: "pullAnimation")
        
    }
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool)
    {
        verticalLine!.path = self.getLinePathWithAmount(0.0)
        verticalLine?.removeAllAnimations()
        
    }
    
    
    func createLine() -> Void
    {
        verticalLine = CAShapeLayer()
        verticalLine!.strokeColor = UIColor.whiteColor().CGColor
        verticalLine!.lineWidth = 5.0
        verticalLine!.fillColor = UIColor.whiteColor().CGColor
        self.view.layer.addSublayer(verticalLine)
    }
    
    
    func getLinePathWithAmount(amount:CGFloat)  -> CGPathRef
    {
        var bezierPath = UIBezierPath()
        var topPoint:CGPoint = CGPointMake(amount,-1)
        var midPoint:CGPoint = CGPointMake(self.view.bounds.size.width/2,amount)
        var bottomPoint:CGPoint = CGPointMake( self.view.bounds.size.width - amount,-1)
        
        bezierPath.moveToPoint(topPoint)
        bezierPath.addQuadCurveToPoint(bottomPoint, controlPoint: midPoint)
        return bezierPath.CGPath
    }
    
    func handleTransitionLeft(recognizer:UIScreenEdgePanGestureRecognizer)
    {
        
        var progress:CGFloat  = recognizer.locationInView(self.view.superview).x / (self.view.superview.bounds.size.width * 1.0)
        progress = min(1.0,max(0.0,progress))
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
                self.interactSlideTransition?.finishInteractiveTransition()
            }
            else
            {
                self.interactSlideTransition?.cancelInteractiveTransition()
            }
            self.interactSlideTransition = nil
        }
    }
    
    func handleTransitionRight(recognizer:UIScreenEdgePanGestureRecognizer)
    {
        var progress:CGFloat  = recognizer.locationInView(self.view.superview).x / (self.view.superview.bounds.size.width * 1.0)
        progress = 1.0 - min(1.0,max(0.0,progress))
        //println("progress \(progress)")
        if recognizer.state == .Began
        {
            self.interactSlideTransition = UIPercentDrivenInteractiveTransition()
            let toVC = self.storyboard.instantiateViewControllerWithIdentifier("PaperViewController") as PaperViewController
            toVC.currentIndex = self.currentIndex + 1
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
                self.interactSlideTransition?.finishInteractiveTransition()
            }
            else
            {
                self.interactSlideTransition?.cancelInteractiveTransition()
            }
            self.interactSlideTransition = nil
        }
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
                self.view.addSubview(imageView)
                UIView.animateWithDuration(0.3, animations: {()->Void in
                    imageView.alpha = 1
                    })
                })
            })
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning!) -> UIViewControllerInteractiveTransitioning!
    {
        return self.interactSlideTransition
    }
    
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning!) -> UIViewControllerInteractiveTransitioning!
    {
        return  self.interactSlideTransition
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

}
