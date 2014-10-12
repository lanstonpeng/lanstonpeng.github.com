//
//  WritingViewController.m
//  MailCat
//
//  Created by Lanston Peng on 10/12/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "WritingViewController.h"
#import "TransitionManager.h"

#define ChineseFont @"FZQKBYSJW--GB1-0"
#define ChineseFont3  @"FZQingKeBenYueSongS-R-GB"

@interface WritingViewController ()<UIViewControllerTransitioningDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *bodyTextView;

@end

@implementation WritingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.transitioningDelegate = self;
    // Do any additional setup after loading the view.
    self.titleField.font = [UIFont fontWithName:ChineseFont size:14];
    self.bodyTextView.font = [UIFont fontWithName:ChineseFont size:14];
    
}
- (IBAction)cancelEditing:(id)sender {
    self.editing = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)handlePanUpGesture:(UIPanGestureRecognizer *)recognizer {
    CGFloat progress  =[recognizer locationInView:self.view.superview].y / (self.view.superview.bounds.size.height * 1.0);
    progress =  MIN(1.0,MAX(0 , progress));
    
    if(recognizer.state == UIGestureRecognizerStateBegan)
    {
        self.interactiveTransition = [UIPercentDrivenInteractiveTransition new];
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        [self.interactiveTransition updateInteractiveTransition:progress];
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
    }
 
}


- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return self.interactiveTransition;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return self.interactiveTransition;
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
