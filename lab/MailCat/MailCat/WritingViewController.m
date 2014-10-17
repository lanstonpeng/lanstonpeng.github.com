//
//  WritingViewController.m
//  MailCat
//
//  Created by Lanston Peng on 10/12/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "WritingViewController.h"
#import "TransitionManager.h"
#import "MBProgressHUD.h"
#import "ResultViewController.h"

#define ChineseFont @"FZQKBYSJW--GB1-0"
#define ChineseFont3  @"FZQingKeBenYueSongS-R-GB"

@interface WritingViewController ()<UIViewControllerTransitioningDelegate,NSLayoutManagerDelegate,UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *bodyTextView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (weak, nonatomic) IBOutlet UILabel *wordCountLabel;
@property (strong,nonatomic)MBProgressHUD* toastMsg;
@end

@implementation WritingViewController
{
    BOOL isAnimationFinished;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.transitioningDelegate = self;
    self.titleField.font = [UIFont fontWithName:ChineseFont size:20];
    self.bodyTextView.font = [UIFont fontWithName:ChineseFont size:15];
    self.bodyTextView.layoutManager.delegate = self;
    self.backButton.alpha = 0;
    self.okButton.alpha = 0;
    isAnimationFinished = YES;
//    UIImageView* bgView = [[UIImageView alloc]initWithFrame:self.view.bounds];
//    bgView.image = [UIImage imageNamed:@"paisaje_azul_2880x1800"];
//    bgView.contentMode = UIViewContentModeScaleAspectFill;
//    bgView.alpha = 0.7;
//    [self.view insertSubview:bgView atIndex:0];
}
-  (void)textViewDidChange:(UITextView *)textView
{
    self.wordCountLabel.text = [NSString stringWithFormat:@"(%lu) %d",(unsigned long)textView.text.length, MAX(0,140 - (int)textView.text.length)];
}

#pragma mark --
#pragma mark titleTextField delegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.text = [NSString stringWithFormat:@"%@:",textField.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager lineSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect
{
    return 7;
}

- (void)displayToastMsg:(NSString*)str
{
    self.toastMsg = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.toastMsg.mode = MBProgressHUDModeText;
    self.toastMsg.labelText = str;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.toastMsg hide:YES];
    });
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if (self.titleField.text.length < 1) {
        [self displayToastMsg:@"信件的开头需要把对方的称呼加上呀"];
        return NO;
    }
    //TODO:change this word count number
    if (self.bodyTextView.text.length < 14) {
        [self displayToastMsg:@"请安静下来,慢慢讲诉你想说的事情,想分享的内容"];
        return NO;
    }
    return YES;
}
- (IBAction)tapViewShowNaviButton:(id)sender {
    
    if (!isAnimationFinished) {
        return;
    }
    
    isAnimationFinished = NO;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.backButton.alpha = 1;
        self.okButton.alpha = 1;
    } completion:^(BOOL finished) {
        [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(hideNaviButton) userInfo:nil repeats:NO];
    }];
}
- (void)hideNaviButton
{
        [UIView animateWithDuration:0.3 delay:0 options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction) animations:^{
            self.backButton.alpha = 0;
            self.okButton.alpha = 0;
        } completion:^(BOOL finished){
            isAnimationFinished = YES;
        }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.letterModel.receiverName = self.titleField.text;
    self.letterModel.letterBody = self.bodyTextView.text;
    ResultViewController* resultVC = (ResultViewController*)segue.destinationViewController;
    //resultVC.letterModel = [self.letterModel copy];
    resultVC.letterModel = self.letterModel;
}

-(IBAction)unwindSegue:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelEditing:(id)sender {
    //self.editing = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)handlePanUpGesture:(UIPanGestureRecognizer *)recognizer {
    return;
    /*
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
     */
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
