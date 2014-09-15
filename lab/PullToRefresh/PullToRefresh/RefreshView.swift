//
//  RreshView.swift
//  PullToRefresh
//
//  Created by Lanston Peng on 9/15/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

import UIKit

protocol RefreshViewDelegate
{
    func refreshViewDidRefreshed()->Void
}

class RefreshView: UIView {

    let cat:UIImageView?
    let cape_back:UIImageView?
    //var delegate:
    
    override init(frame: CGRect) {
        cat = UIImageView(image: UIImage(named:"cat"))
        cape_back = UIImageView(image: UIImage(named:"cape_back"))
        super.init(frame: frame)
        self.backgroundColor = UIColor.orangeColor()
        self.addSubview(cat!)
        self.addSubview(cape_back!)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func ScrollViewDidScroll(scrollView:UIScrollView) -> Void
    {
        let visibleHeight:CGFloat = max(-scrollView.contentOffset.y - scrollView.contentInset.top, 0);
        cat?.center = CGPointMake(cat!.center.x, cat!.center.y + visibleHeight)
    }

}
