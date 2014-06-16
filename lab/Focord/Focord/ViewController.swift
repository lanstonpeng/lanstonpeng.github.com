//
//  ViewController.swift
//  Focord
//
//  Created by Lanston Peng on 6/14/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var btn : UIButton
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        btn.titleLabel.text = "mail"
        btn.backgroundColor = UIColor.whiteColor()

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

