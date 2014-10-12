//
//  TransitionManager.m
//  MailCat
//
//  Created by Lanston Peng on 10/12/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "TransitionManager.h"

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
    NSTimeInterval duraiton = [self transitionDuration:transitionContext];
    
    
    toViewController.view.alpha = 0;
    [containerView addSubview:toViewController.view];
    
    [UIView animateWithDuration:duraiton delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        fromViewController.view.alpha = 0;
        toViewController.view.alpha = 1;
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
    
    [containerView insertSubview:toViewController.view aboveSubview:fromViewController.view];
    toViewController.view.alpha = 0;
    [UIView animateWithDuration:duraiton delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        fromViewController.view.alpha = 0;
        toViewController.view.alpha = 1;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

@end
