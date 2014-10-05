//
//  AddNewAppViewController.m
//  OneThingWell
//
//  Created by Lanston Peng on 10/1/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "AddNewAppViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface AddNewAppViewController ()<UITextViewDelegate,MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@end


@implementation AddNewAppViewController
{
    BOOL hasTextViewChanged;
}

- (IBAction)closeSelf:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)handleTapGesture:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

- (IBAction)prepareSending:(id)sender {
    if (_nameTextField.text.length < 1) {
        return;
    }
    
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;
        [mailCont setSubject:_nameTextField.text];
        [mailCont setToRecipients:[NSArray arrayWithObject:@"lanstonpeng@daikeapp.com"]];
        [mailCont setMessageBody:_descriptionTextView.text isHTML:NO];
        [self presentViewController:mailCont animated:YES completion:nil];
    }
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 10)];
//    [_nameTextField setLeftViewMode:UITextFieldViewModeAlways];
//    [_nameTextField setLeftView:spacerView];
    //_descriptionTextView.contentInset = UIEdgeInsetsMake(5, 30, 5, 0);
    hasTextViewChanged = NO;
    // Do any additional setup after loading the view.
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (!hasTextViewChanged) {
        hasTextViewChanged = YES;
        textView.alpha = 1;
        textView.textAlignment = NSTextAlignmentLeft;
        textView.textColor = [UIColor colorWithRed:98/255 green:0 blue:255/255 alpha:1];
        textView.text = @"";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
