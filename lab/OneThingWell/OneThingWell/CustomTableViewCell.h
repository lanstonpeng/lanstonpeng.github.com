//
//  CustomTableViewCell.h
//  OneThingWell
//
//  Created by Lanston Peng on 9/24/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *pubTime;
@property (weak, nonatomic) IBOutlet UIView *backgroundAlphaView;
@property (weak, nonatomic) IBOutlet UIView *textBackgroundAlpahView;

@property (nonatomic)NSUInteger row;
@end
