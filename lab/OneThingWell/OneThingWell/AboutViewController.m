//
//  AboutViewController.m
//  OneThingWell
//
//  Created by Lanston Peng on 9/25/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "AboutViewController.h"
#import "WebPageViewController.h"
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>
#import <StoreKit/StoreKit.h>

@interface AboutViewController ()<MFMailComposeViewControllerDelegate,SKStoreProductViewControllerDelegate>

@end

#define appURL @"https://itunes.apple.com/us/app/onethingwell/id925227155?ls=1&mt=8"
@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:{
                    
                    WebPageViewController* webPage = [self.storyboard instantiateViewControllerWithIdentifier:@"webviewPage"];
                    webPage.webpageURLString = @"http://onethingwell.org/post/457050307/about-one-thing-well";
                    [self.navigationController pushViewController:webPage animated:YES];
                    break;
                }
                case 1:
                {
                
                    UIViewController* aboutVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutAppID"];
                    [self.navigationController pushViewController:aboutVC animated:YES];
                    break;
                }
                case 2:
                {
                    if([MFMailComposeViewController canSendMail]) {
                        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
                        mailCont.mailComposeDelegate = self;
                        [mailCont setSubject:@"[OTW]Contact"];
                        [mailCont setToRecipients:[NSArray arrayWithObject:@"lanstonpeng@gmail.com"]];
                        [mailCont setMessageBody:@"" isHTML:NO];
                        [self presentViewController:mailCont animated:YES completion:nil];
                    }
                    break;
                }
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                {
                    
                    SKStoreProductViewController* SKVC = [[SKStoreProductViewController alloc]init];
                    SKVC.delegate = self;
                    [SKVC loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier : @"925227155"} completionBlock:^(BOOL result, NSError *error) {
                    }];
                    [self presentViewController:SKVC animated:YES completion:nil];
                    break;
                }
                case 1:{
                    UIAlertControllerStyle alertStyle = UIAlertControllerStyleActionSheet;
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                                   message:appURL
                                                                            preferredStyle:alertStyle];
                    
                    UIAlertAction* copyAction = [UIAlertAction actionWithTitle:@"Copy URL" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                        pasteboard.string = appURL;
                    }];
                    
                    UIAlertAction* twitterAction = [UIAlertAction actionWithTitle:@"Twitter" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
                        {
                            SLComposeViewController *tweetSheetOBJ = [SLComposeViewController
                                                                      composeViewControllerForServiceType:SLServiceTypeTwitter];
                            NSString* str = [NSString stringWithFormat:@"I like this App: %@",appURL];
                            [tweetSheetOBJ setInitialText:str];
                            [self presentViewController:tweetSheetOBJ animated:YES completion:nil];
                        }
                        
                    }];
                    
                    UIAlertAction* faceBookAction = [UIAlertAction actionWithTitle:@"Facebook" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
                            SLComposeViewController *fbSheetOBJ = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                            
                            NSString* str2 = [NSString stringWithFormat:@"I like this App: %@",appURL];
                            [fbSheetOBJ setInitialText:str2];
                            [self presentViewController:fbSheetOBJ animated:YES completion:Nil];
                        }
                        
                    }];
                    
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"CANCEL"
                                                                           style:UIAlertActionStyleDestructive
                                                                         handler:^(UIAlertAction *action) {
                        
                                                                         }];
                    [alert addAction:copyAction];
                    [alert addAction:twitterAction];
                    [alert addAction:faceBookAction];
                    [alert addAction:cancelAction];
                    [self presentViewController:alert
                                       animated:YES
                                     completion:^{
                                         
                                     }];
                }
                    
                default:
                    break;
            }
            
        default:
            break;
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
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
