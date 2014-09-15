//
//  ViewController.swift
//  PullToRefresh
//
//  Created by Lanston Peng on 9/15/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var refreshView:RefreshView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshView = RefreshView(frame: CGRectMake(0, -120, self.view.bounds.width, 120))
        self.tableView.backgroundColor = UIColor.purpleColor()
        //self.tableView.alpha = 0.4
        self.view.insertSubview(refreshView!, aboveSubview: self.tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        refreshView?.ScrollViewDidScroll(scrollView)
    }
    
    //MARK:-
    //MARK:Datasource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("customCell") as UITableViewCell
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
}

