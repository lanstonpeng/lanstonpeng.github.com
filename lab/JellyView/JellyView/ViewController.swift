//
//  ViewController.swift
//  JellyView
//
//  Created by Lanston Peng on 7/24/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let jellyView = JellyView(frame: CGRectMake(100, 100, 100, 100))
        self.view.addSubview(jellyView)
        let animator = UIDynamicAnimator(referenceView: self.view)
        
        let gravityItem = UIGravityBehavior(items: jellyView.subviews)
        gravityItem.magnitude = 2
        //animator.addBehavior(gravityItem)
        jellyView.mainAnimator?.addBehavior(gravityItem)
        
        let collision = UICollisionBehavior(items: jellyView.subviews)
        collision.translatesReferenceBoundsIntoBoundary = true
        jellyView.mainAnimator?.addBehavior(collision)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

