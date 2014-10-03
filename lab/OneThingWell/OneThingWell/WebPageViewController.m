//
//  WebPageViewController.m
//  OneThingWell
//
//  Created by Lanston Peng on 9/24/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "WebPageViewController.h"
#import <WebKit/WebKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Social/Social.h>

@interface WebPageViewController ()<WKNavigationDelegate,UINavigationBarDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end

@implementation WebPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

- (void)willMoveToParentViewController:(UIViewController *)parent
{
    if(!parent)
    {
        //self.tabBarController.tabBar.hidden = NO;
    }
}
- (IBAction)clickShareButton:(id)sender {
    
//    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0);
//    
//    
//    [self.view.window drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:NO];
//    
//    UIImage *copied = UIGraphicsGetImageFromCurrentImageContext();
//    UIImageView* imgView = [[UIImageView alloc]initWithFrame:self.view.bounds];
//    imgView.image = copied;
//    UIBlurEffect* effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//    UIVisualEffectView* visualEffectView = [[UIVisualEffectView alloc]initWithEffect:effect];
//    visualEffectView.frame = self.view.bounds;
//    [imgView addSubview:visualEffectView];
//    
//    UIGraphicsEndImageContext();
//    //[self.view addSubview:imgView];
//    
//    //self.view.hidden = !self.view.hidden;
//    self.navigationController.navigationBar.hidden = self.navigationController.navigationBar.hidden;
    
    UIAlertControllerStyle alertStyle = UIAlertControllerStyleActionSheet;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:self.webpageURLString
                                                            preferredStyle:alertStyle];
    
    UIAlertAction* copyAction = [UIAlertAction actionWithTitle:@"Copy URL" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.webpageURLString;
    }];
    
    UIAlertAction* twitterAction = [UIAlertAction actionWithTitle:@"Twitter" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            SLComposeViewController *tweetSheetOBJ = [SLComposeViewController
                                                      composeViewControllerForServiceType:SLServiceTypeTwitter];
            NSString* str = [NSString stringWithFormat:@"I like this thing: %@",self.webpageURLString];
            [tweetSheetOBJ setInitialText:str];
            [self presentViewController:tweetSheetOBJ animated:YES completion:nil];
        }

    }];
    
    UIAlertAction* faceBookAction = [UIAlertAction actionWithTitle:@"Facebook" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            SLComposeViewController *fbSheetOBJ = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            NSString* str2 = [NSString stringWithFormat:@"I like this thing: %@",self.webpageURLString];
            [fbSheetOBJ setInitialText:str2];
            [self presentViewController:fbSheetOBJ animated:YES completion:Nil];
        }

    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"CANCEL"
                                                           style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction *action) {
                                                             
                                                             NSLog(@"CANCEL!");
                                                         }];
    [alert addAction:copyAction];
    [alert addAction:twitterAction];
    [alert addAction:faceBookAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert
                       animated:YES
                     completion:^{
                         //[imgView removeFromSuperview];
                     }];
}

- (void)loadView{
    [super loadView];
    CGRect sFrame = [UIScreen mainScreen].bounds;
    WKWebView* webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, sFrame.size.width, self.view.frame.size.height)];
    
    //load page from cache
//    if (self.webpageContent) {
//    }
//    else
//    {
//    }
    
    NSURLRequest* request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:_webpageURLString]];
    webView.navigationDelegate = self;
    webView.allowsBackForwardNavigationGestures = YES;
    [self.view insertSubview:webView belowSubview:self.loadingIndicator];
    [webView loadRequest:request];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSLog(@"%@",navigation);
    //[self.loadingIndicator stopAnimating];
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id obj, NSError* error) {
        self.title = (NSString*)obj;
    }];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
