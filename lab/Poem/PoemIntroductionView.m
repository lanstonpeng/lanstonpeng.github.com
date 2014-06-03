//
//  PoemIntroductionView.m
//  Poem
//
//  Created by Lanston Peng on 6/2/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "PoemIntroductionView.h"

@implementation PoemIntroductionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UILabel* l = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        l.text = @"ASdf";
        l.backgroundColor= [UIColor orangeColor];
        self.backgroundColor = [UIColor purpleColor];
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
