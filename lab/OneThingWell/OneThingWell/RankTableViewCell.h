//
//  RankTableViewCell.h
//  OneThingWell
//
//  Created by Lanston Peng on 10/6/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RankTableViewCell : UITableViewCell

@property (strong,nonatomic)NSString* webURLStr;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@end
