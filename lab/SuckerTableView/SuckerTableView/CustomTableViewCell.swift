//
//  CustomTableViewCell.swift
//  SuckerTableView
//
//  Created by Lanston Peng on 9/23/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

import UIKit


@IBDesignable
class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var content: UILabel!
    
    @IBInspectable var backColor:UIColor = UIColor.clearColor(){
        didSet{
            //self.layer.borderWidth = 10
            //self.layer.borderColor = backColor.CGColor
            //self.backgroundColor = backColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
