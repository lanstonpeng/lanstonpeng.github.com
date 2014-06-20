//
//  TimeBar.m
//  LineSum
//
//  Created by Lanston Peng on 4/19/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "TimeBarView.h"

#define PROGRESS_DURATION 0.2f

@interface TimeBarView()
@end

@implementation TimeBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.percentage = 1;
    }
    return self;
}
/*
- (void)drawRect:(CGRect)rect
{
    NSLog(@"%f",self.percentage * IPHONE_SCREEN_WIDTH);
    CGRect rectangle = CGRectMake(0, 0, IPHONE_SCREEN_WIDTH * self.percentage, 10);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIColorFromRGB(0x52ce90) setFill];
    CGContextFillRect(context, rectangle);
}
 */

-(void)dropProgressByPersentage:(double)delta{
    if(self.percentage > 0.0){
        self.percentage -= delta;
#warning how to deal with the animate queue
        [UIView animateWithDuration:PROGRESS_DURATION animations:^{
            self.frame = CGRectMake(0, 0, IPHONE_SCREEN_WIDTH * self.percentage, 10);
        }];
    }
    else{
        if([self.delegate respondsToSelector:@selector(onTimesUp)]){
            [self.delegate performSelector:@selector(onTimesUp)];
        }
    }
}
-(void)addProgressByPersentage:(double)delta{
    if(self.percentage <= 1.0){
        self.percentage += delta;
    }
}
@end
