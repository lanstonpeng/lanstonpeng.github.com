//
//  LoadingView.m
//  Poem
//
//  Created by Lanston Peng on 6/13/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView

#define ChineseFont @"FZQKBYSJW--GB1-0"
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGRect sFrame = [UIScreen mainScreen].bounds;
        UILabel* l = [[UILabel alloc]initWithFrame:CGRectMake(0, sFrame.size.height / 2 - 50, sFrame.size.width, sFrame.size.height)];
        l.text = @"诗";
        l.font = [UIFont fontWithName:ChineseFont size:40];
        l.textAlignment = NSTextAlignmentCenter;
        l.textColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor blackColor];
        l.backgroundColor = [UIColor clearColor];
        [self addSubview:l];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
