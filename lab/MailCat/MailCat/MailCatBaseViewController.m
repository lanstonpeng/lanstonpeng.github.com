//
//  MailCatBaseViewController.m
//  MailCat
//
//  Created by Lanston Peng on 10/20/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "MailCatBaseViewController.h"
#import "TransitionManager.h"

@interface MailCatBaseViewController ()<UIViewControllerTransitioningDelegate,UIGestureRecognizerDelegate>

@end

@implementation MailCatBaseViewController
{
    CGFloat startPanX;
}

- (void)setPanDirection:(UIRectEdge)panDirection
{
    _panDirection = panDirection;
    UIScreenEdgePanGestureRecognizer* screenEdgePan = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
    screenEdgePan.edges = panDirection;
    [self.view addGestureRecognizer:screenEdgePan];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.transitioningDelegate = self;
    //self.isByClick = YES;
}

- (void)handlePanGesture:(UIScreenEdgePanGestureRecognizer*)recognizer
{
    CGFloat currentX = [recognizer locationInView:self.view.superview].x;
    CGFloat progress = ( currentX - startPanX ) / (self.view.superview.bounds.size.width );
    progress = MIN(1.0,MAX(0 , progress));
    
    if(recognizer.state == UIGestureRecognizerStateBegan)
    {
        self.isByClick = NO;
        
        MailCatBaseViewController * viewController = [self.storyboard instantiateViewControllerWithIdentifier:self.storyBoardIdentifier];
        self.interactiveTransition = [UIPercentDrivenInteractiveTransition new];
        viewController.interactiveTransition = self.interactiveTransition;
        viewController.isByClick = NO;
        if (self.panDirection == UIRectEdgeLeft) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            [self presentViewController:viewController animated:YES completion:nil];
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        NSLog(@"progress: %f",progress);
        [self.interactiveTransition updateInteractiveTransition:progress];
        //self.paperImageView.frame = CGRectOffset(self.paperImageView.frame, 0, -progress * 10);
    }
    else if(recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled)
    {
        if (progress > 0.5) {
            [self.interactiveTransition finishInteractiveTransition];
        }
        else
        {
            [self.interactiveTransition cancelInteractiveTransition];
        }
        self.interactiveTransition = nil;
        self.isByClick = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator
{
    NSLog(@"%@",self.storyBoardIdentifier);
    return self.isByClick? nil : self.interactiveTransition;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    NSLog(@"%@",self.storyBoardIdentifier);
    return self.isByClick? nil : self.interactiveTransition;
}


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    if (presented == self) {
        return (id<UIViewControllerAnimatedTransitioning>)[[TransitionManager alloc]init:YES];
    }
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    if (dismissed == self) {
        return (id<UIViewControllerAnimatedTransitioning>)[[TransitionManager alloc]init:NO];
    }
    return nil;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
