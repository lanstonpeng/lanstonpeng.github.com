//
//  CustomPresentaionController.m
//  ObjcCustomTransition
//
//  Created by Lanston Peng on 7/30/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "CustomPresentaionController.h"

@interface CustomPresentaionController()

@property (strong,nonatomic)UIView* chromeView;

@end

@implementation CustomPresentaionController


- (UIView *)chromeView
{
    if(!_chromeView)
    {
        _chromeView = [[UIView alloc]initWithFrame:self.containerView.bounds];
        _chromeView.backgroundColor = [UIColor yellowColor];
        _chromeView.alpha = 0;
        _chromeView.clipsToBounds = YES;
    }
    return _chromeView;
}
- (void)presentationTransitionWillBegin
{
    for (UIView* view in self.containerView.subviews) {
        NSLog(@"%d",(int)view.tag);
    }
    [self.containerView addSubview:self.chromeView];
    [self.containerView addSubview:[self presentedView]];
    
    
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = [self.presentingViewController transitionCoordinator];
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.chromeView.alpha = 1;
    } completion:nil];
    
}

- (void)presentationTransitionDidEnd:(BOOL)completed
{
    if (!completed) {
        [self.chromeView removeFromSuperview];
    }
}

- (void)dismissalTransitionWillBegin
{
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = [self.presentingViewController transitionCoordinator];
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.chromeView.alpha = 0;
    } completion:nil];
}

- (void)dismissalTransitionDidEnd:(BOOL)completed
{
    if(completed)
    {
        [self.chromeView removeFromSuperview];
        for (UIView* view in self.containerView.subviews) {
            NSLog(@"%d",(int)view.tag);
        }
    }
}

- (CGRect)frameOfPresentedViewInContainerView
{
    return CGRectInset(self.containerView.frame, 0, 100);
}
@end
