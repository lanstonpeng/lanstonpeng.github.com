//
//  MarginLabel.m
//  MailCat
//
//  Created by Lanston Peng on 10/26/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "MarginLabel.h"

@implementation MarginLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {0, 40, 0, 40};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
