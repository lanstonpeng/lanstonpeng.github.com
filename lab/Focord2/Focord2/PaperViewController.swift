//
//  PaperViewController.swift
//  CustomTransition
//
//  Created by Lanston Peng on 7/31/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

import UIKit
import QuartzCore

class PaperViewController: UIViewController ,UIViewControllerTransitioningDelegate,UIGestureRecognizerDelegate,MotionManagerDelegate{

    //MARK: helper property
    let sBounds = UIScreen.mainScreen().bounds
    var centerView : UIView?
    var animator: UIDynamicAnimator!
    
    //MARK: macro
    let RECORD_CELL_WIDTH:CGFloat = 120
    let CENTER_VIEW_WIDTH:CGFloat = 2
    var interactSlideTransition:UIPercentDrivenInteractiveTransition?
    
    let CELL_FINAL_FRAME:CGRect
    //TODO:add page count support
    var pageCount = 5
    internal var currentIndex = 0
    
    var hasNextRecord:Bool = true
    var verticalLine:CAShapeLayer?
    
    
    //MARK: record cell property
    var pullDownSwipe:UIPanGestureRecognizer?
    var currentRecordCell:RecordCell?
    var canDeleteRecordCell:Bool
    
    //MARK: cell drop gesture
    var dropCellPan:UIPanGestureRecognizer?
    var isLineAnimated:Bool
    
    //MARK: motionManager
    var motionManager:MotionManager?
    
    
    required init(coder aDecoder: NSCoder!)
    {
        
        CELL_FINAL_FRAME = CGRectMake(self.sBounds.width/2 - self.RECORD_CELL_WIDTH/2, self.sBounds.height/2 - self.RECORD_CELL_WIDTH/2, self.RECORD_CELL_WIDTH, self.RECORD_CELL_WIDTH)
        isLineAnimated = false
        canDeleteRecordCell = false
        super.init(coder: aDecoder)
    }
    func generateRandomColor() -> UIColor
    {
        let num = arc4random() % 4
        switch num
        {
        default:
            return UIColor.orangeColor()
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
        
        motionManager = MotionManager()
        motionManager?.delegate = self
        self.createLine()
        
        //    NSString* levelPath = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"];
        //    _levelConfig = [NSArray arrayWithContentsOfFile:levelPath];
        
        self.modalPresentationStyle = .Custom
        self.transitioningDelegate = self
        
        //self.view.clipsToBounds = true
        let edgeSwipeGestureRight = UIScreenEdgePanGestureRecognizer(target: self, action: "handleTransitionRight:")
        edgeSwipeGestureRight.edges = .Right
        
        self.view.addGestureRecognizer(edgeSwipeGestureRight)
        
        self.view.backgroundColor = self.generateRandomColor()
        
        self.initViewDecoration()
        
        let edgeSwipeGestureLeft = UIScreenEdgePanGestureRecognizer(target: self, action: "handleTransitionLeft:")
        edgeSwipeGestureLeft.edges = .Left
        self.view.addGestureRecognizer(edgeSwipeGestureLeft)
        
        animator = UIDynamicAnimator(referenceView: view)
        centerView = UIView(frame: CGRectMake(self.sBounds.width/2 - self.CENTER_VIEW_WIDTH/2, self.sBounds.height/2 - self.CENTER_VIEW_WIDTH/2, self.CENTER_VIEW_WIDTH, self.CENTER_VIEW_WIDTH))
        self.centerView?.alpha = 0
        
        self.addPullGesture()
        //self.initPic()
        
    }
    //MARK: cell drop delete Gesture
    func addDropCellGesture()
    {
        dropCellPan = UIPanGestureRecognizer(target: self, action: "handleDropCell:")
        dropCellPan?.delegate = self
        self.currentRecordCell?.addGestureRecognizer(dropCellPan!)
    }
    func removeDropCellGesture()
    {
        self.currentRecordCell?.removeGestureRecognizer(dropCellPan!)
    }
    
    func handleDropCell(recognizer:UIPanGestureRecognizer)
    {
        if recognizer.state == .Began
        {
            self.removePullGesture()
            //var attach = UIAttachmentBehavior(item: self.currentRecordCell!, attachedToAnchor: CGPointMake(160, 300))
            //animator.addBehavior(attach)
        }
        else if recognizer.state == .Changed
        {
            let translation = recognizer.translationInView(self.view)
            
            recognizer.view.center = CGPoint(x:recognizer.view.center.x + translation.x,
                y:recognizer.view.center.y + translation.y)
            
            recognizer.setTranslation(CGPointZero, inView: recognizer.view)
        }
        else if recognizer.state == .Ended
        {
            let v = recognizer.velocityInView(recognizer.view)
            
            if abs(v.x) < 50 && abs(v.y) < 50
            {
                UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {() -> Void in
                    
                    recognizer.view.center = CGPointMake(self.sBounds.width/2, self.sBounds.height/2)
                    
                    }, completion: { (completed) -> Void in
                })
            }
            else
            {
                self.currentRecordCell?.removeFromSuperview()
                canDeleteRecordCell = false
                self.addPullGesture()
            }
        }

    }
    func removeRecordCell()
    {
    }
    
    //MARK: top pull down cell stuff
    func removePullGesture()
    {
        self.view.removeGestureRecognizer(pullDownSwipe!)
    }
    
    func addPullGesture()
    {
        pullDownSwipe = UIPanGestureRecognizer(target: self, action: "handlePullDown:")
        pullDownSwipe?.delegate = self
        self.view.addGestureRecognizer(pullDownSwipe!)
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer!, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer!) -> Bool
    {
        return true
    }
    
    
    
    
    func handlePullDown(recoginzer:UIPanGestureRecognizer)
    {
        let deltaY:CGFloat = recoginzer.translationInView(self.view).y
        
        let location:CGPoint = recoginzer.locationInView(self.view)
        
        //println(recoginzer.velocityInView(self.view))
        
        if( recoginzer.state == UIGestureRecognizerState.Began)
        {
            var recordCell:RecordCell = RecordCell(frame: CGRectMake(sBounds.width/2 - RECORD_CELL_WIDTH/2, -RECORD_CELL_WIDTH, RECORD_CELL_WIDTH, RECORD_CELL_WIDTH))
            
            self.currentRecordCell = recordCell
            self.addDropCellGesture()
            self.view.addSubview(recordCell)
        }
        
        canDeleteRecordCell = true
        
        //release your figure during the pulling
        if (recoginzer.state == UIGestureRecognizerState.Changed)
        {
            if(deltaY > 0)
            {
                //in pulling down process
                if(deltaY < 100)
                {
                    verticalLine!.path = self.getLinePathWithAmount(deltaY)
                    self.currentRecordCell!.center.y = deltaY - RECORD_CELL_WIDTH
                    
                }
                // ready to present the dropping cell
                else
                {
                    canDeleteRecordCell = false
                    self.removePullGesture()
                    self.animateLine(min(deltaY,100))
                    self.presentRecordCell()
                }
            }
        }
        else if recoginzer.state == UIGestureRecognizerState.Ended
        {
            if deltaY > 0 && deltaY < 100
            {
                self.currentRecordCell?.removeFromSuperview()
                self.animateLine(deltaY)
            }
            
        }
    }
    func animateLine(PositionY:CGFloat)
    {
        if isLineAnimated == false
        {
            isLineAnimated = true
            let keyFA:CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "path")
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
        
    }
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool)
    {
        verticalLine!.path = self.getLinePathWithAmount(0.0)
        //self.addPullGesture()
        isLineAnimated = false
        if canDeleteRecordCell == true
        {
            self.currentRecordCell?.removeFromSuperview()
        }
        //motionManager!.boundView = currentRecordCell
        self.addRotateAnimation()
        self.currentRecordCell?.addBreathingAnimation()
        motionManager?.startListen()
        verticalLine?.removeAllAnimations()
        
    }
    func addRotateAnimation()
    {
        //TODO:swing after a few milliseconds
    }
    
    
    func createLine() -> Void
    {
        verticalLine = CAShapeLayer()
        verticalLine!.strokeColor = UIColor.whiteColor().CGColor
        verticalLine!.lineWidth = 2.0
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
    
    //MARK: record Cell
    func presentRecordCell()
    {
        
        UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.2, options: UIViewAnimationOptions.CurveEaseIn, animations: {() -> Void in
                self.currentRecordCell!.frame = CGRectMake(self.sBounds.width/2 - self.RECORD_CELL_WIDTH/2, self.sBounds.height/2 - self.RECORD_CELL_WIDTH/2, self.RECORD_CELL_WIDTH, self.RECORD_CELL_WIDTH)
            }, completion: {(completed:Bool ) -> Void in
            
            })
    }
    
    
    //MARK: Screen Edge Gesture
    func handleTransitionLeft(recognizer:UIScreenEdgePanGestureRecognizer)
    {
        
        var progress:CGFloat  = recognizer.locationInView(self.view.superview).x / (self.view.superview!.bounds.size.width * 1.0)
        progress = min(1.0,max(0.0,progress))
        if recognizer.state == .Began
        {
            self.interactSlideTransition = UIPercentDrivenInteractiveTransition()
            self.removePullGesture()
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
            //self.interactSlideTransition = nil
        }
    }
    
    func handleTransitionRight(recognizer:UIScreenEdgePanGestureRecognizer)
    {
        var progress:CGFloat  = recognizer.locationInView(self.view.superview).x / (self.view.superview!.bounds.size.width * 1.0)
        progress = 1.0 - min(1.0,max(0.0,progress))
        //println("progress \(progress)")
        if recognizer.state == .Began
        {
            self.interactSlideTransition = UIPercentDrivenInteractiveTransition()
            self.removePullGesture()
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
            //self.interactSlideTransition = nil
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
    
    
    
    
    //MARK: Motion Delegate
    func deviceDidFlipToBack() {
        self.currentRecordCell?.indicatorLabel.text = "\(motionManager!.duration)"
        println("did flip to back \(motionManager!.duration)")
        
    }
    
    func deviceDidFlipToFront() {
        println("did flip to front \(motionManager!.duration)")
    }

}
