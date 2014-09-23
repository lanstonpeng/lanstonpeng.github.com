//
//  ViewController.swift
//  SuckerTableView
//
//  Created by Lanston Peng on 9/23/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

import UIKit

class ViewController: UITableViewController,UITableViewDataSource,UITableViewDelegate {

    var entry:NSArray! = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entry.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("reuse") as CustomTableViewCell
        if entry.count > 0{
            cell.content.text = entry[indexPath.row]["im:name"] as NSString
        }
        return cell
    }


}

