    //
//  ViewController.swift
//  CustomTransition
//
//  Created by Lanston Peng on 7/9/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController,UINavigationControllerDelegate {
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController.navigationBar.backgroundColor = UIColor.clearColor()
        var line = self.findHairLine(self.navigationController.navigationBar)
        if let l = line{
            l.hidden = true
        }
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        self.navigationController.delegate = self
    }
    override  func viewWillDisappear(animated: Bool)
    {
        if self.conformsToProtocol(UINavigationControllerDelegate)
        {
           self.navigationController.delegate = nil
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!)
    {
        if segue.destinationViewController.isKindOfClass(SecondViewController.self)
        {
            //println("ready for launching second view controller")
            let secondVC:SecondViewController = SecondViewController()
            
        }
    }
    func navigationController(navigationController: UINavigationController!, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController!, toViewController toVC: UIViewController!) -> UIViewControllerAnimatedTransitioning!
    {
        if(fromVC == self && toVC.isKindOfClass(SecondViewController.self))
        {
            return TransitionFromFirstToSecond()
        }
        return nil
    }
    
    
    func findHairLine(view:UIView ) -> UIImageView?
    {
        if(view.isKindOfClass(UIImageView.self) && view.bounds.size.height<=1.0)
        {
            return view as? UIImageView
        }
        for subview in view.subviews
        {
            //NSLog("\(subview)")
            let imageView = self.findHairLine(subview as UIView)
            if (imageView?.isKindOfClass(UIImageView.self)) {
                return imageView
            }
        }
        return nil;
    }
}


