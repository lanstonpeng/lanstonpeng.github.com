//
//  TransitionManager.m
//  MailCat
//
//  Created by Lanston Peng on 10/12/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "TransitionManager.h"
#import "MailCatUtil.h"

@interface TransitionManager()<UIViewControllerAnimatedTransitioning>

@property (nonatomic)BOOL isPresent;

@end

@implementation TransitionManager

- (instancetype)init:(BOOL)present
{
    self = [super init];
    if (self) {
        self.isPresent = present;
    }
    return self;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (_isPresent) {
        [self animateTransitionForPresent:transitionContext];
    }
    else
    {
        [self animateTransitionForDismiss:transitionContext];
    }
    
}

- (void)animateTransitionForPresent:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView* containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [containerView addSubview:toViewController.view];
    
    CGRect displayFrame = fromViewController.view.frame;
    CGRect hiddenFrame = CGRectOffset(displayFrame, displayFrame.size.width , 0);
    toViewController.view.frame = hiddenFrame;
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        fromViewController.view.alpha = 0;
        toViewController.view.frame = displayFrame;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}


- (void)animateTransitionForDismiss:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView* containerView = [transitionContext containerView];
    NSTimeInterval duraiton = [self transitionDuration:transitionContext];
    
    [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
    toViewController.view.alpha = 0;
    
    CGRect displayFrame = fromViewController.view.frame;
    CGRect hiddenFrame = CGRectOffset(displayFrame, displayFrame.size.width , 0);
    toViewController.view.frame = displayFrame;
    
    [UIView animateWithDuration:duraiton delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        fromViewController.view.frame = hiddenFrame;
        toViewController.view.alpha = 1;
    } completion:^(BOOL finished) {
        [containerView insertSubview:toViewController.view aboveSubview:fromViewController.view];
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}

@end
