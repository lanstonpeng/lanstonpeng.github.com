//
//  MailTableViewCell.h
//  MailCat
//
//  Created by Lanston Peng on 10/17/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *senderMailLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeNeededLabel;
@property (weak, nonatomic) IBOutlet UILabel *clipContentLabel;

@end
