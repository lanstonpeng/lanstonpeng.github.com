//
//  AnotherViewController.m
//  ParallelScroll
//
//  Created by Lanston Peng on 6/8/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "AnotherViewController.h"
#import "CustomCell.h"

@interface AnotherViewController()
{

    CGRect sFrame;
    CGRect currentFrame;
    CGRect nextFrame;
    CGPoint touchBeganPoint;
    int currentIdx;
    int count;
}

@property (strong,nonatomic)CustomCell* prevCustomCellRef;
@property (strong,nonatomic)CustomCell* currentCustomCellRef;
@property (strong,nonatomic)CustomCell* nextCustomCellRef;

@property (strong,nonatomic)NSDate* lastTime;

@end

#define ScrollYVelocityThreshold 5
#define kDeltaIntervalTHreshold 0.2f
#define kDecelerationDuration 0.4f
#define kDamping 5.0f

//#define logPoint
@implementation AnotherViewController

- (void)viewDidLoad
{
    count = 3;
     sFrame = [UIScreen mainScreen].bounds;
     currentFrame = CGRectMake(0, 0, sFrame.size.width, sFrame.size.height);
     nextFrame = CGRectMake(0, sFrame.size.height, sFrame.size.width, sFrame.size.height);
    _currentCustomCellRef = [[CustomCell alloc]initWithFrame:self.view.frame];
    [self.view addSubview:_currentCustomCellRef];
    if (count >1) {
        _nextCustomCellRef = [[CustomCell alloc]initWithFrame:nextFrame];
        [self.view addSubview:_nextCustomCellRef];
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    CGPoint prevPoint = [touch previousLocationInView:self.view];
    
    CGPoint targetPoint;
    CGPoint targetPointCurrent;
    NSDate *currentTime = [NSDate date];
    NSTimeInterval interval = [currentTime timeIntervalSinceDate:self.lastTime];
    NSLog(@"currentTime %f",interval);
#ifdef logPoint
    NSLog(@"End:%f,%f",currentPoint.y,prevPoint.y);
#endif
    
    //NSLog(@"End:%f",currentPoint.y - touchBeganPoint.y);
    targetPoint.x = nextFrame.size.width/2;
    targetPointCurrent.x = nextFrame.size.width/2;
    //targetPoint.y = (currentPoint.y - touchBeganPoint.y)/interval * kDecelerationDuration/kDamping;
    targetPoint.y = (currentPoint.y - touchBeganPoint.y);
    
    //move to next page if it scroll fast enough
    //calculate the Y veolocity
    if (interval < kDeltaIntervalTHreshold) {
        //swipe up
        if(targetPoint.y < 0)
        {
            targetPoint.y = nextFrame.size.height/2;
            targetPointCurrent.y = _currentCustomCellRef.layer.position.y - sFrame.size.height;
        }
        //swipe down
        else
        {
            targetPoint.y = nextFrame.size.height*1.5;
            targetPointCurrent.y = currentFrame.size.height/2;
        }
        /*CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithControlPoints:
                                                 0.1f : 0.9f :0.2f :1.0f];
        CABasicAnimation* animationNext = [CABasicAnimation animationWithKeyPath:@"position.y"];
        //animationNext.duration = kDecelerationDuration;
        animationNext.fromValue = @(_nextCustomCellRef.layer.position.y);
        animationNext.toValue = @(targetPoint.y);
        animationNext.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];;
        animationNext.fillMode = kCAFillModeForwards;
        //animation.removedOnCompletion = NO;
        CABasicAnimation* animationCurrent = [CABasicAnimation animationWithKeyPath:@"position.y"];
        animationCurrent.fromValue = @(_currentCustomCellRef.layer.position.y);
        animationCurrent.toValue = @(targetPointCurrent.y);
        animationCurrent.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];;
        animationCurrent.fillMode = kCAFillModeForwards;
        
        CAAnimationGroup* group = [CAAnimationGroup animation];
        group.duration = kDecelerationDuration;
        group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];;
        group.animations = @[animationNext,animationCurrent];
        
        [self.view.layer addAnimation:group forKey:@"tester"];*/
        [UIView animateWithDuration:kDecelerationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _nextCustomCellRef.layer.position = targetPoint;
        } completion:^(BOOL finished) {
            
        }];
        [UIView animateWithDuration:kDecelerationDuration delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _currentCustomCellRef.layer.position = targetPointCurrent;
        } completion:^(BOOL finished) {
            
        }];
    }
    //it's a dragging
    else{
        if(_nextCustomCellRef.frame.origin.y >= sFrame.size.height/2)
        {
            [self scrollBackToPrevPage];
        }
        else
        {
            [self scrollToNewPage];
        }
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    CGPoint prevPoint = [touch previousLocationInView:self.view];
    CGFloat deltaY = currentPoint.y - prevPoint.y;
#ifdef logPoint
    NSLog(@"Moved:%f,%f",currentPoint.y,prevPoint.y);
#endif
    _nextCustomCellRef.frame = CGRectOffset(_nextCustomCellRef.frame, 0, deltaY);
    _currentCustomCellRef.frame  = CGRectOffset(_currentCustomCellRef.frame, 0, deltaY/2);
    /*
    NSDate *currentTime = [NSDate date];
    NSTimeInterval interval = [currentTime timeIntervalSinceDate:self.lastTime];
    if (interval >= kDeltaIntervalTHreshold) {
    }
     */
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    CGPoint prevPoint = [touch previousLocationInView:self.view];
    touchBeganPoint = currentPoint;
#ifdef logPoint
    NSLog(@"Began:%f,%f",currentPoint.y,prevPoint.y);
#endif
    _lastTime = [NSDate date];
}
- (void)scrollBackToPrevPage
{
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _nextCustomCellRef.frame = nextFrame;
        _currentCustomCellRef.frame = currentFrame;
    } completion:^(BOOL finished) {
    }];
}
- (void)scrollToNewPage
{
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _nextCustomCellRef.frame = currentFrame;
    } completion:^(BOOL finished) {
    }];
}
@end
