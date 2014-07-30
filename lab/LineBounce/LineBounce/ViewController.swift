//
//  ViewController.swift
//  LineBounce
//
//  Created by Lanston Peng on 7/25/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController {
    
    var verticalLine:CAShapeLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createLine()
        let panGesture = UIPanGestureRecognizer()
        panGesture.addTarget(self, action: "handlePan:")
        self.view.addGestureRecognizer(panGesture)
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    func handlePan(panGes:UIPanGestureRecognizer)
    {
        let x:CGFloat = panGes.translationInView(self.view).x
        if(x > 0)
        {
            if(x < 270)
            {
                verticalLine!.path = self.getLinePathWithAmount(x)
                
                if panGes.state == UIGestureRecognizerState.Ended
                {
                    self.animateLine(x)
                }
            }
            else
            {
                self.animateLine(x)
            }
        }
    }
    
    func animateLine(PositionX:CGFloat)
    {
        let keyFA = CAKeyframeAnimation(keyPath: "path")
        keyFA.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        let values = [
            self.getLinePathWithAmount(PositionX),
            //self.getLinePathWithAmount(-PositionX * 0.9),
            //self.getLinePathWithAmount(PositionX * 0.6),
            //self.getLinePathWithAmount(-PositionX * 0.4),
            //self.getLinePathWithAmount(PositionX * 0.25),
            //self.getLinePathWithAmount(PositionX * 0)
        ]
        println(keyFA)
        println(values)
        keyFA.values = values
        keyFA.duration = 0.6
        keyFA.removedOnCompletion = false
        keyFA.fillMode = kCAFillModeForwards
        keyFA.delegate = self
        verticalLine?.addAnimation(keyFA, forKey: "tester")
        
    }

    override func animationDidStop(anim: CAAnimation!, finished flag: Bool)
    {
        verticalLine!.path = self.getLinePathWithAmount(0.0)
        verticalLine?.removeAllAnimations()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createLine() -> Void
    {
        self.view.backgroundColor = UIColor.orangeColor()
        verticalLine = CAShapeLayer()
        verticalLine!.strokeColor = UIColor.greenColor().CGColor
        verticalLine!.lineWidth = 5.0
        verticalLine!.fillColor = UIColor.clearColor().CGColor
        self.view.layer.addSublayer(verticalLine)
    }
    
    
    func getLinePathWithAmount(amount:CGFloat)  -> CGPathRef
    {
        var bezierPath = UIBezierPath()
        var topPoint:CGPoint = CGPointMake(-1,amount)
        var midPoint:CGPoint = CGPointMake(amount, self.view.bounds.size.height/2)
        var bottomPoint:CGPoint = CGPointMake(-1, self.view.bounds.size.height - amount)
        
        bezierPath.moveToPoint(topPoint)
        bezierPath.addQuadCurveToPoint(bottomPoint, controlPoint: midPoint)
        return bezierPath.CGPath
    }


}

