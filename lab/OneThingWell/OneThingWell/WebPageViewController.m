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
    
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0);
    
    
    [self.view.window drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:NO];
    
    UIImage *copied = UIGraphicsGetImageFromCurrentImageContext();
    UIImageView* imgView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    imgView.image = copied;
    UIBlurEffect* effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView* visualEffectView = [[UIVisualEffectView alloc]initWithEffect:effect];
    visualEffectView.frame = self.view.bounds;
    [imgView addSubview:visualEffectView];
    
    UIGraphicsEndImageContext();
    //[self.view addSubview:imgView];
    
    //self.view.hidden = !self.view.hidden;
    self.navigationController.navigationBar.hidden = self.navigationController.navigationBar.hidden;
    
    UIAlertControllerStyle alertStyle = UIAlertControllerStyleActionSheet;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:self.webpageURLString
                                                            preferredStyle:alertStyle];
    UIAlertAction* copyAction = [UIAlertAction actionWithTitle:@"Copy URL" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.webpageURLString;
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"CANCEL"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action) {
                                                             
                                                             NSLog(@"CANCEL!");
                                                         }];
    [alert addAction:copyAction];
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
//    [self.view addConstraints:@[
//                                [NSLayoutConstraint constraintWithItem:webView
//                                                             attribute:NSLayoutAttributeWidth
//                                                             relatedBy:NSLayoutRelationEqual
//                                                                toItem:self.view
//                                                             attribute:NSLayoutAttributeWidth
//                                                            multiplier:1.0
//                                                              constant:0],
//                                [NSLayoutConstraint constraintWithItem:webView
//                                                             attribute:NSLayoutAttributeHeight
//                                                             relatedBy:NSLayoutRelationEqual
//                                                                toItem:self.view
//                                                             attribute:NSLayoutAttributeHeight
//                                                            multiplier:1.0
//                                                              constant:0]
//                                ]];
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
