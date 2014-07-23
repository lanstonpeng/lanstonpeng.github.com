//
//  PresentationInitViewController.swift
//  CustomTransition
//
//  Created by Lanston Peng on 7/16/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

import UIKit

class PresentationInitViewController: UIViewController {

    @IBOutlet var presentBtn: UIButton?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presentBtn!.addTarget(self, action: "handlePresent:", forControlEvents: UIControlEvents.TouchUpInside);
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handlePresent(sender:UIButton)
    {
        let pVC:PresentaionViewController = self.storyboard.instantiateViewControllerWithIdentifier("presentVC") as PresentaionViewController
        self.presentViewController(pVC, animated: true, completion:nil)
    }
    
    
    

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
