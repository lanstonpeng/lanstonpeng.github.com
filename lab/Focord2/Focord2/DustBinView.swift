//
//  DustBinView.swift
//  Focord2
//
//  Created by Lanston Peng on 8/7/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

import UIKit
import QuartzCore

class DustBinView: UIView {

    var verticalLine:CAShapeLayer?
    internal var deleteLabel:UILabel?
    internal let sBounds:CGRect
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
    }
    */
    required init(coder aDecoder: NSCoder!) {
        sBounds = UIScreen.mainScreen().bounds
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        sBounds = UIScreen.mainScreen().bounds
        
        deleteLabel = UILabel(frame: CGRectMake(0, 0, frame.size.width, frame.size.height - 20))
        deleteLabel?.text = "Drop here to delete"
        deleteLabel?.font = UIFont(name: "Apple SD Gothic Neo", size: 20)
        deleteLabel?.textAlignment = NSTextAlignment.Center
        deleteLabel?.textColor = UIColor.blackColor()
        
        verticalLine?.path
        super.init(frame: frame)
        self.addSubview(deleteLabel!)
    }
    func createLine() -> Void
    {
        verticalLine = CAShapeLayer()
        verticalLine!.strokeColor = UIColor.whiteColor().CGColor
        verticalLine!.lineWidth = 2.0
        verticalLine!.fillColor = UIColor.clearColor().CGColor
        self.layer.addSublayer(verticalLine)
    }
    
    internal func getLinePathWithAmount(amount:CGFloat)  -> CGPathRef
    {
        var bezierPath = UIBezierPath()
        var topPoint:CGPoint = CGPointMake(amount,sBounds.size.height - 20 )
        var midPoint:CGPoint = CGPointMake(sBounds.size.width/2,amount)
        var bottomPoint:CGPoint = CGPointMake( sBounds.size.width - amount,sBounds.size.height - 20 )
        
        bezierPath.moveToPoint(topPoint)
        bezierPath.addQuadCurveToPoint(bottomPoint, controlPoint: midPoint)
        return bezierPath.CGPath
    }

}
