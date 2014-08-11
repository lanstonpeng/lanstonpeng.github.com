//
//  RecordCell.swift
//  Focord2
//
//  Created by Lanston Peng on 8/2/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

import UIKit
import QuartzCore

class RecordCell: UIView,NSCopying {

    var radius:CGFloat = 40//半径
    var startX:CGFloat = 50//圆心x坐标
    var startY:CGFloat = 50//圆心y坐标
    var pieStart:CGFloat = 0//起始的角度
    var pieCapacity:CGFloat = 10//角度增量值
    var clockwise:Int32 = 1//0=逆时针,1=顺时针
    
    var duration:CGFloat = 0
    var indicatorLabel:UILabel
    internal var f:CGRect
    
    required init(coder aDecoder: NSCoder!) {
        indicatorLabel = UILabel(frame:CGRectZero)
        f = CGRectZero
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        indicatorLabel = UILabel(frame: CGRectMake(0, 0, frame.size.width, frame.size.height))
        f = frame
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.layer.cornerRadius = frame.size.width/2
        self.clipsToBounds = false
        self.initUI()
        // Initialization code
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject! {
        let c:RecordCell = RecordCell(frame: self.f)
        c.indicatorLabel.text = self.indicatorLabel.text
        return c
    }
    func addBreathingAnimation()
    {
        let baseAnimation = CABasicAnimation(keyPath: "transform.scale")
        baseAnimation.fromValue = NSValue(CATransform3D: CATransform3DIdentity)
        baseAnimation.toValue = NSValue(CATransform3D: CATransform3DMakeScale(1.3, 1.3, 1.0))
        baseAnimation.duration = 1.2
        baseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        baseAnimation.repeatCount = 100
        baseAnimation.autoreverses = true
        baseAnimation.fillMode = "forwards"
        self.layer.addAnimation(baseAnimation, forKey: "scaleUpDown")
    }
    
    func addCountingDownCircleAnimation()
    {
        
    }
    
    func addRotateAnimation()
    {
        //TODO:swing after a few milliseconds
    }
    
    func initUI()
    {
        // flip label
        //indicatorLabel = UILabel(frame: CGRectMake(0, 0, frame.size.width, frame.size.height))
        indicatorLabel.font = UIFont(name: "Apple SD Gothic Neo", size: 20)
        indicatorLabel.textAlignment = NSTextAlignment.Center
        indicatorLabel.textColor = UIColor.orangeColor()
        indicatorLabel.text = "FLIP"
        //self.layer.transform = CATransform3DMakeRotation( CGFloat(45 * M_PI / 180), 1.0, 1.0, 0.0)
        self.addSubview(indicatorLabel)
        
        startX = 20
        startY = 20
        //NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "updateSector", userInfo: nil, repeats: true)
    }
    
    func updateSector()
    {
        pieCapacity += 10
        self.setNeedsDisplay()
    }

    func radians(degree:CGFloat) -> CGFloat
    {
       return 3.1415926 * degree / 180
    }
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    /*
    override func drawRect(rect: CGRect)
    {
        let context:CGContextRef = UIGraphicsGetCurrentContext()
        CGContextSetRGBStrokeColor(context, 0, 0, 0, 1)
        CGContextSetLineWidth(context, 0.6)
        CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 1.0)
        CGContextMoveToPoint(context, startX, startY)
        CGContextAddArc(context, startX, startY, radius, radians(pieStart), radians(pieStart+pieCapacity), clockwise)
        CGContextClosePath(context)
        CGContextDrawPath(context, kCGPathEOFillStroke)
    }
    */

}
