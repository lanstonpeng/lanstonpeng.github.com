//
//  MailTableViewCell.m
//  MailCat
//
//  Created by Lanston Peng on 10/17/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "MailTableViewCell.h"

@implementation MailTableViewCell
{
    CGRect sFrame;
}

- (void)awakeFromNib {
    // Initialization code
    NSLog(@"cell awakeFrom Nib");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame
{
    sFrame = [UIScreen mainScreen].bounds;
    CGFloat inset = sFrame.size.width * 0.03;
    frame.origin.x += inset;
    frame.origin.y += inset;
    frame.size.width -= 2 * inset;
    frame.size.height -= inset;
    [super setFrame:frame];
}

@end
