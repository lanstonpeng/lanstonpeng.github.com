//
//  ToViewController.m
//  ObjcCustomTransition
//
//  Created by Lanston Peng on 7/29/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "ToViewController.h"
#import "TransitionAnimatior.h"

@interface ToViewController()<UIViewControllerTransitioningDelegate>



@end

@implementation ToViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    self.transitioningDelegate = self;
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    
    [button setTitle:@"Back" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    
    
    UIScreenEdgePanGestureRecognizer* edgePan = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    edgePan.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:edgePan];
}

- (void)handlePan:(UIScreenEdgePanGestureRecognizer*)recognizer
{
    CGFloat progress = [recognizer locationInView:self.view.superview].x / self.view.bounds.size.width * 1.0;
    
    progress = MAX(0, MIN(progress,1));
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:{
            self.interactiveTransition = [UIPercentDrivenInteractiveTransition new];
            self.isByClick = NO;
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
        case UIGestureRecognizerStateChanged:{
            [self.interactiveTransition updateInteractiveTransition:progress];
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        {
            if(progress > 0.5)
            {
                [self.interactiveTransition finishInteractiveTransition];
            }
            else
            {
                [self.interactiveTransition cancelInteractiveTransition];
            }
            break;
        }
            
        default:
            break;
    }
}

- (void)handleClick:(UIButton*)btn
{
    self.isByClick = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [[TransitionAnimatior alloc]initWithType:NO];
}


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [[TransitionAnimatior alloc]initWithType:YES];
}


- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return _isByClick ? nil : self.interactiveTransition;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return _isByClick ? nil : self.interactiveTransition;
}


@end
