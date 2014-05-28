//
//  LScrollView.m
//  LScrollView
//
//  Created by Lanston Peng on 4/26/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "LScrollView.h"

@interface LScrollView()
@property(nonatomic)CGPoint lastPoint;
@property(nonatomic)BOOL isRight;
@property (nonatomic)CGPoint offsetPoint;
@property (nonatomic)float delta;
@end

@implementation LScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _lastPoint = CGPointZero;
        self.clipsToBounds = YES;
    }
    return self;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch* touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self];
    _offsetPoint = self.bounds.origin;
    _lastPoint = [touch previousLocationInView:self];
    NSLog(@"%f",pt.x);
    if( pt.x - _lastPoint.x == 0){
        return;
    }
    //paning right
    if(pt.x - _lastPoint.x >0 ){
        _isRight = YES;
        _delta = pt.x - _lastPoint.x;
        _offsetPoint.x -= _delta;
    }
    //paning left
    else{
        _delta = _lastPoint.x - pt.x ;
        _offsetPoint.x += _delta;
        _isRight = NO;
    }
    [self setBounds:CGRectMake(_offsetPoint.x,0, self.frame.size.width, self.frame.size.height)];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{

    [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bounds = CGRectMake(_offsetPoint.x + (_isRight ? - _delta : _delta),0, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
    }];
}

@end
