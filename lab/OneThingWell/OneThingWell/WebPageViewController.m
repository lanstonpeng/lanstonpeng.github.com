//
//  WebPageViewController.m
//  OneThingWell
//
//  Created by Lanston Peng on 9/24/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "WebPageViewController.h"
#import <WebKit/WebKit.h>

@interface WebPageViewController ()<WKNavigationDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end

@implementation WebPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

- (void)loadView{
    [super loadView];
    WKWebView* webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 30, 320, 600)];
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSLog(@"%@",navigation);
    [self.loadingIndicator stopAnimating];
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
