//
//  testView.m
//  LayerTester
//
//  Created by Lanston Peng on 6/9/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "testView.h"

@implementation testView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CALayer* layer = [CALayer layer];
        layer.frame = CGRectMake(100, 200, 100, 100);
        //[self.layer addSublayer:layer];
        //layer.contents = (id) [UIImage imageNamed:@"Quill.png"].CGImage;
        CALayer* customDrawn = [CALayer layer];
        customDrawn.delegate = self;
        customDrawn.backgroundColor = [UIColor greenColor].CGColor;
        customDrawn.frame = CGRectMake(30, 250, 128, 40);
        customDrawn.shadowOffset = CGSizeMake(0, 3);
        customDrawn.shadowRadius = 5.0;
        customDrawn.shadowColor = [UIColor blackColor].CGColor;
        customDrawn.shadowOpacity = 0.8;
        customDrawn.cornerRadius = 10.0;
        customDrawn.borderColor = [UIColor blackColor].CGColor;
        customDrawn.borderWidth = 2.0;
        customDrawn.masksToBounds = YES;
        
        [self.layer addSublayer:customDrawn];
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
