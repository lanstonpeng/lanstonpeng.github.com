//
//  WritingViewController.m
//  MailCat
//
//  Created by Lanston Peng on 10/12/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "WritingViewController.h"
#import "TransitionManager.h"
#import "ResultViewController.h"
#import "WritingTextView.h"
#import "MailCatUtil.h"


#define ChineseFont @"FZQKBYSJW--GB1-0"
#define ChineseFont3  @"FZQingKeBenYueSongS-R-GB"

@interface WritingViewController ()<UIViewControllerTransitioningDelegate,NSLayoutManagerDelegate,UITextFieldDelegate,UITextViewDelegate>
@property (strong, nonatomic) UITextField *titleField;
@property (weak, nonatomic) IBOutlet WritingTextView  *bodyTextView;
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
    
    self.titleField = [[UITextField alloc]initWithFrame:CGRectMake(15, 50, 80, 40)];
    self.titleField.placeholder = @"称谓:";
    self.titleField.font = [UIFont fontWithName:ChineseFont size:20];
    self.titleField.delegate = self;
    //self.titleField.text = @"sucker";
    
    self.bodyTextView.font = [UIFont fontWithName:ChineseFont size:15];
    //self.bodyTextView.textAlignment = NSTextAlignmentCenter;
    self.bodyTextView.showsVerticalScrollIndicator = NO;
    self.bodyTextView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    self.bodyTextView.layoutManager.delegate = self;
    self.bodyTextView.textContainerInset = UIEdgeInsetsMake(90, 20, 20, 20);
    
    
    
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
    
    [self.bodyTextView addSubview:self.titleField];
}

-  (void)textViewDidChange:(UITextView *)textView
{
    self.wordCountLabel.text = [NSString stringWithFormat:@"(%lu) %d",(unsigned long)textView.text.length, MAX(0,140 - (int)textView.text.length)];
    
//    NSArray* paragraphs = [textView.text componentsSeparatedByString:@"\n"];
//    NSMutableString* str = [NSMutableString new];
//    [paragraphs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        NSString* paragraphPiece = (NSString*)obj;
//        if (paragraphPiece.length < 5) {
//            //[str appendString: [NSString stringWithFormat:@"\n%@",paragraphPiece]];
//            textView.text = str;
//            return;
//        }
//        NSString* beginString = [paragraphPiece substringToIndex:4];
//        
//        if (![beginString containsString:@"    "]) {
//            [str appendString: [NSString stringWithFormat:@"    %@",paragraphPiece]];
//        }
//    }];
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
    return 10;
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
        [[MailCatUtil singleton]displayToastMsg:@"漏了称呼了呀" inView:self.view];
        return NO;
    }
    //TODO:change this word count number
    if (self.bodyTextView.text.length < 14) {
        NSString* msg = [NSString stringWithFormat:@"字数太少了,至少还要%d个字",MAX(0,140 - (int)self.bodyTextView.text.length)];
        [[MailCatUtil singleton]displayToastMsg:msg inView:self.view afterDelay:1.5];
        return NO;
    }
    return YES;
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
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



- (void)keyboardWillShow:(NSNotification *)notification
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.bodyTextView.textAlignment = NSTextAlignmentLeft;
    });
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets;
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.height)+  50, 0.0);
    } else {
        contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.width) + 50, 0.0);
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
