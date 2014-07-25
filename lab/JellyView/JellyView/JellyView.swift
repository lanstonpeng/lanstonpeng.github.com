//
//  JellyView.swift
//  JellyView
//
//  Created by Lanston Peng on 7/24/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

import UIKit

class JellyView: UIView {

    var mainAnimator:UIDynamicAnimator?
    
    init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
        mainAnimator = UIDynamicAnimator(referenceView: self)
        self.initDotViews()
    }
    
    func initDotViews()
    {
        let nDivisions = 3
        let viewSize = self.frame.size
        
        var item = 0
        for(var i = 0; i < nDivisions ; i++)
        {
            for(var k = 0 ; k < nDivisions ; k++)
            {
                let hSeparation = Int(viewSize.width) / (nDivisions - 1);
                let vSeparation = Int(viewSize.height) / (nDivisions - 1);
                
                let hAmountToCenter = self.bounds.size.width/2 - viewSize.width/2;
                let vAmountToCenter = self.bounds.size.height/2 - viewSize.height/2;
                
                let view = UIView(frame:CGRectMake(self.bounds.origin.x + hAmountToCenter + hSeparation*k,
                    self.bounds.origin.y + vAmountToCenter + vSeparation*i,
                    10,
                    10))
                view.tag = item;
                view.backgroundColor = UIColor.greenColor()
                self.addSubview(view)
                item += 1;
            }
        }
        self.attachViews()
    }
    
    func attachViews()
    {
        let viewSize = self.frame.size
        let nDivisions = 3
        let separation  = Int(viewSize.width) / (nDivisions - 1)
        for(var i = 0; i < self.subviews.count;i++)
        {
            let view:UIView = self.subviews[i] as UIView
            
            for  otherSubView in self.subviews
            {
                println(view.center.x - otherSubView.center.x - separation)
                if view.center.x - otherSubView.center.x - separation == 0 || view.center.y - otherSubView.center.y - separation == 0
                {
                    //let attach:UIAttachmentBehavior = UIAttachmentBehavior(item: view, attachedToItem: otherSubView)
                    let attach:UIAttachmentBehavior = UIAttachmentBehavior(item: view, attachedToItem: otherSubView)
                    //let attach = UIAttachmentBehavior(item: view, attachedToAnchor: view.center)
                    //let attach = UIAttachmentBehavior(item: view, offsetFromCenter: UIOffsetZero, attachedToItem: otherSubView, offsetFromCenter: UIOffsetZero)
                    attach.damping = 0.4
                    attach.frequency = 15
                    self.mainAnimator?.addBehavior(attach)
                    
                    let item = UIDynamicItemBehavior(items: [view])
                    item.elasticity = 1.2
                    item.density = 2
                    self.mainAnimator?.addBehavior(item)
                }
            }
        }
        /*
self.mainAnimator = [[UIDynamicAnimator alloc]initWithReferenceView:self];
CGFloat separation = self.viewSize.width/(self.nDivisions - 1);
for (int i = 0; i < [self.subviews count]; i++) {
UIView *view = self.subviews[i];
for (UIView *nextView in self.subviews) {
if ((view.center.x - nextView.center.x == separation)||(view.center.y - nextView.center.y == separation)) {
UIAttachmentBehavior *attach = [[UIAttachmentBehavior alloc]initWithItem:view
attachedToItem:nextView];
attach.damping = self.damping;
attach.frequency = self.frequency;
[self.mainAnimator addBehavior:attach];

UIDynamicItemBehavior *bh = [[UIDynamicItemBehavior alloc]initWithItems:@[view]];
bh.elasticity = self.elasticity;
bh.density = self.density;
[self.mainAnimator addBehavior:bh];
}
}
}*/
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
    }
    */

}
