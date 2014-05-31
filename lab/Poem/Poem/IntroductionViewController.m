//
//  IntroductionViewController.m
//  Poem
//
//  Created by Lanston Peng on 5/30/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "IntroductionViewController.h"
#import "ContainerViewController.h"
#import "MainPageViewController.h"
#import "UIImage+PoemResouces.h"
#import <QuartzCore/QuartzCore.h>

@interface IntroductionViewController ()<UIScrollViewDelegate>
{
    UIImageView* bgView;
    UIScrollView* bgScrollView;
    UIView* scrollIndicatorView;
    BOOL isChanging;
}
@property (strong,nonatomic)ContainerViewController* sharedContainerViewController;
@end

@implementation IntroductionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _sharedContainerViewController =  [ContainerViewController sharedViewController];
    
    CGRect sFrame = [UIScreen mainScreen].bounds;
    bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, sFrame.size.width + 20 , sFrame.size.height)];
    CALayer* bgMaskLayer = [CALayer layer];
    bgMaskLayer.opacity = 0.5;
    bgMaskLayer.frame = CGRectMake(-20, 0, sFrame.size.width + 40 , sFrame.size.height);
    bgMaskLayer.backgroundColor = [UIColor blackColor].CGColor;
    [bgView.layer addSublayer:bgMaskLayer];
    UIImage* backgroundImg = (UIImage*)[[UIImage alloc]initWithName:@"Shakespeare"];

    bgView.image = backgroundImg;
    [self.view addSubview:bgView];
    
    bgScrollView = [[UIScrollView alloc]initWithFrame:bgView.frame];
    bgScrollView.contentSize = CGSizeMake(bgScrollView.frame.size.width + 1 , bgScrollView.frame.size.height );
    bgScrollView.delegate = self;
    bgScrollView.showsVerticalScrollIndicator = NO;
    [bgScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    UILabel* author = [[UILabel alloc]initWithFrame:CGRectMake(10, sFrame.size.height - 200 , sFrame.size.width - 20, 100)];
    author.text = @"William Shakespeare";
    author.numberOfLines = 0;
    author.textAlignment = NSTextAlignmentRight;
    author.font = [UIFont fontWithName: @"Helvetica-Bold" size:40];
    author.textColor = [UIColor whiteColor];
    
    UIView* separator = [[UIView alloc]initWithFrame:CGRectMake(20, author.frame.origin.y + author.frame.size.height + 10, sFrame.size.width - 20, 0.5 )];
    scrollIndicatorView = [[UIView alloc]initWithFrame:CGRectMake(separator.frame.origin.x, separator.frame.origin.y,0,separator.frame.size.height)];
    scrollIndicatorView.backgroundColor = [UIColor blackColor];
    separator.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:separator];
    [self.view addSubview:scrollIndicatorView];
    
    UILabel* title = [[UILabel alloc]initWithFrame:CGRectMake(10, sFrame.size.height - 100 , sFrame.size.width- 20, 100)];
    title.text = @"Sonnet - Shall I compare thee to a summer's day";
    title.font = [UIFont fontWithName:@"STHeitiSC-Light" size:16];
    title.numberOfLines = 0;
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentRight;
    
    
    [bgScrollView addSubview:author];
    [bgScrollView addSubview:title];
    [self.view addSubview:bgScrollView];
    
   
    UISwipeGestureRecognizer* swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(nextPage)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
}
- (void)nextPage
{
    MainPageViewController* mainController = [MainPageViewController new];
    [_sharedContainerViewController pushViewController: mainController];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.x <= 0){
        scrollView.contentOffset = CGPointMake(0, 0);
        return;
    }
    if(scrollView.contentOffset.x > 80 && !isChanging)
    {
        scrollView.scrollEnabled = NO;
        isChanging = YES;
        NSLog(@"changing ");
        [self nextPage];
        return;
    }
    bgView.frame = CGRectMake(-scrollView.contentOffset.x / 10, bgView.frame.origin.y, bgView.frame.size.width, bgView.frame.size.height);
    //NSLog(@"%f",scrollView.contentOffset.x);
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.scrollEnabled) {
        [UIView animateWithDuration:0.5 animations:^{
            scrollView.contentOffset = CGPointMake(0, 0);
        } completion:^(BOOL finished) {
            
        }];
    }
}
- (void)didMoveToParentViewController:(UIViewController *)parent{
    bgScrollView.scrollEnabled = YES;
    isChanging = NO;
    [UIView animateWithDuration:0.5 animations:^{
        bgScrollView.contentOffset = CGPointMake(0, 0);
    } completion:^(BOOL finished) {
        
    }];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"contentOffset"])
    {
        scrollIndicatorView.frame = CGRectMake(scrollIndicatorView.frame.origin.x , scrollIndicatorView.frame.origin.y,
                                              300 *
                                               bgScrollView.contentOffset.x / 80 , scrollIndicatorView.frame.size.height);
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
