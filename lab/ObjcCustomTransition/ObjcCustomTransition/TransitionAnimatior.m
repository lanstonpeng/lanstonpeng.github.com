//
//  TransitionAnimatior.m
//  ObjcCustomTransition
//
//  Created by Lanston Peng on 7/29/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "TransitionAnimatior.h"


@interface TransitionAnimatior()

@property (nonatomic) BOOL isPresent;

@end

@implementation TransitionAnimatior

-(instancetype)initWithType:(BOOL)isPresent{
    
    if(self = [super init])
    {
        self.isPresent = isPresent;
    }
    return  self;
    
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (self.isPresent) {
        [self presentAnimate:transitionContext];
    }
    else
    {
        [self dismissAnimate:transitionContext];
    }
}

-(void)presentAnimate:(id<UIViewControllerContextTransitioning>)transitionContext
{
   
    UIViewController* fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController* toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView* containerView = [transitionContext containerView];
    
   
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
    toVC.view.frame = CGRectOffset(finalFrame,screenBounds.size.width,0);
    
    [containerView addSubview:toVC.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        toVC.view.frame = finalFrame;
        fromVC.view.frame = CGRectOffset(fromVC.view.frame, -160, 0);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
    
}
-(void)dismissAnimate:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController* fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController* toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView* containerView = [transitionContext containerView];
    
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
    
    toVC.view.frame = CGRectOffset(finalFrame,-screenBounds.size.width,0);
    [containerView insertSubview:toVC.view aboveSubview:fromVC.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        toVC.view.frame = finalFrame;
        fromVC.view.frame = CGRectOffset(fromVC.view.frame, 160, 0);
        
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3f;
}

@end
