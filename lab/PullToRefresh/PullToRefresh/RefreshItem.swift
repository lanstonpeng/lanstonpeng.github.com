//
//  RefreshItem.swift
//  PullToRefresh
//
//  Created by Lanston Peng on 9/15/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

import UIKit

class RefreshItem: NSObject {
    
    var percent:CGFloat!
    var startPoint:CGPoint!
    var parallaxRatio:CGFloat!
    
    func initItem(view:UIView!,endPoint:CGPoint,parallaxRatio:CGFloat,screenHeight:CGFloat) -> UIView
    {
       
        
        startPoint = CGPointMake(endPoint.x, endPoint.y + screenHeight)
        percent = 0
        return view
    }
}
