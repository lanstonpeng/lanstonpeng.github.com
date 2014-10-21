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
    self.storyBoardIdentifier = @"writingViewController";
    self.titleField.font = [UIFont fontWithName:ChineseFont size:20];
    self.bodyTextView.font = [UIFont fontWithName:ChineseFont size:15];
    self.bodyTextView.textAlignment = NSTextAlignmentCenter;
    self.bodyTextView.showsVerticalScrollIndicator = NO;
    self.bodyTextView.layoutManager.delegate = self;
    self.backButton.alpha = 0;
    self.okButton.alpha = 0;
    self.panDirection = UIRectEdgeLeft;
    isAnimationFinished = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
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

- (void)keyboardWillShow:(NSNotification *)notification
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.bodyTextView.textAlignment = NSTextAlignmentLeft;
    });
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets;
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.height), 0.0);
    } else {
        contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.width), 0.0);
    }
    
    self.bodyTextView.contentInset = contentInsets;
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.bodyTextView.contentInset = UIEdgeInsetsZero;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
