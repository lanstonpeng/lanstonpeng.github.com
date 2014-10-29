//
//  AboutViewController.m
//  MailCat
//
//  Created by Lanston Peng on 10/28/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "AboutViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface AboutViewController ()<MFMailComposeViewControllerDelegate>

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)unwindVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)writeAppReview
{
    //NSString *str = @"itms-apps://itunes.com/apps/mailcat";
    NSString *str = @"itms-apps://itunes.apple.com/app/id933719851";
    //NSString *str = @"itms-apps://itunes.apple.com/app/id893065675";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (IBAction)showMail:(id)sender
{
    NSString *emailTitle = @"[Mail]Recommendation && Suggestion";
    // Email Content
    NSString *messageBody = @"hi mailcater:\n   I'm very glad to hear from you :)";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"lanstonpeng@gmail.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    [self presentViewController:mc animated:YES completion:NULL];
}
#pragma mark mail delegate
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
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
