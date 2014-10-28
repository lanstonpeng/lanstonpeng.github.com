//
//  EntranceViewController.m
//  MailCat
//
//  Created by Lanston Peng on 10/12/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "EntranceViewController.h"
#import "TransitionManager.h"
#import "WritingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AVFoundation/AVFoundation.h"
#import "introductionView.h"
#import <AVOSCloud/AVOSCloud.h>
#import "LetterUser.h"
#import "MailCatUtil.h"
#import "LetterInBoxViewController.h"
#import "RegistrationViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "Reachability.h"

@interface EntranceViewController ()<RegistrationViewControllerDelegate,UIScrollViewDelegate>


@property (weak, nonatomic) IBOutlet UIButton *prepareWritingBtn;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UIScrollView *introScrollView;
@property (weak, nonatomic) IBOutlet UIButton *inboxButton;

@property (strong,nonatomic)AVPlayer* player;

@property (strong,nonatomic)AVPlayerLayer *playerLayer;
@end


@implementation EntranceViewController
{
    CALayer* shadowLayer;
    BOOL isConnected;
}
- (IBAction)showSideMenu:(id)sender {
}

- (void)showInboxICON
{
    AVUser* currentUser = [AVUser currentUser];
    if(currentUser){
        AVQuery* query = [AVQuery queryWithClassName:@"_User"];
        [query whereKey:@"username" equalTo:currentUser.email];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (objects.count > 0) {
                AVUser* user = (AVUser*)[objects firstObject];
                if ([[user objectForKey:@"hasNewMail"] boolValue]) {
                    [self.inboxButton setImage:[UIImage imageNamed:@"gotMail"] forState:UIControlStateNormal];
                }
            }
        }];
    }
}
- (void)initUI
{
    self.prepareWritingBtn.layer.cornerRadius = 4;
    self.prepareWritingBtn.layer.borderWidth = 0.5;
    self.prepareWritingBtn.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)showIntroductionView
{
    NSArray* arr1 = [[NSBundle mainBundle]loadNibNamed:@"introductionView" owner:nil options:nil];
    introductionView* introView1 = (introductionView*)[arr1 firstObject];
    introView1.titleLabel.text = @"安静";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:@"在纷繁的网络世界中追寻一份安静,重新拾起书信时代的纯粹"];
    NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
    [paragrahStyle setLineSpacing:7];
    paragrahStyle.alignment = NSTextAlignmentCenter;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragrahStyle range:NSMakeRange(0, [introView1.contentLabel.text length])];
    
    introView1.contentLabel.attributedText = attributedString ;
    
    NSArray* arr2 = [[NSBundle mainBundle]loadNibNamed:@"introductionView" owner:nil options:nil];
    introductionView* introView2 = (introductionView*)[arr2 firstObject];
    introView2.titleLabel.text = @"耐心";
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc]initWithString:@"信件的送递需要一定的时间,需要屏幕前的你耐心等待对方的回信"];
    [attributedString2 addAttribute:NSParagraphStyleAttributeName value:paragrahStyle range:NSMakeRange(0, [introView2.contentLabel.text length])];
    introView2.contentLabel.attributedText = attributedString2;
    
    introView1.frame = CGRectMake(0, 0, self.introScrollView.frame.size.width, self.introScrollView.frame.size.height);
    introView2.frame = CGRectOffset(introView1.frame, introView1.frame.size.width, 0);
    
    [self.introScrollView addSubview:introView1];
    [self.introScrollView addSubview:introView2];
    self.introScrollView.contentSize = CGSizeMake(introView1.frame.size.width * 2, self.introScrollView.frame.size.height) ;
    self.introScrollView.contentMode = UIViewContentModeCenter;
}

#pragma mark --
#pragma mark add video layer
- (void)showVideoLayer
{
    
    //NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"Remember to Write-HD" ofType:@"mp4"];
    //NSString* videoName = [NSString stringWithFormat:@"cut%d",(int)arc4random()%2 + 1];
    NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"cut1" ofType:@"mp4"];
    NSURL* url = [NSURL fileURLWithPath:videoPath];
    self.player = [AVPlayer playerWithURL:url];
    self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    self.player.volume = 0;
    
    _playerLayer = [AVPlayerLayer layer];
    [_playerLayer setPlayer:self.player];
    [_playerLayer setFrame:self.view.bounds];
    [_playerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[self.player currentItem]];
    
    [self.player addObserver:self forKeyPath:@"status" options:0 context:nil];
    
    shadowLayer = [CALayer layer];
    shadowLayer.frame = self.view.bounds;
    shadowLayer.backgroundColor = [UIColor blackColor].CGColor;
    shadowLayer.opacity = 1;
    
    [self.view.layer insertSublayer:_playerLayer atIndex:0];
    [self.view.layer insertSublayer:shadowLayer above:_playerLayer];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    if (object == self.player && [keyPath isEqualToString:@"status"]) {
        if (self.player.status == AVPlayerStatusReadyToPlay) {
            NSLog(@"Ready to Player");
            CABasicAnimation* playerLayerAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            playerLayerAnimation.fromValue = @1;
            playerLayerAnimation.toValue = @0.4;
            playerLayerAnimation.duration = 3;
            playerLayerAnimation.fillMode = kCAFillModeForwards;
            playerLayerAnimation.removedOnCompletion = NO;
            [shadowLayer addAnimation:playerLayerAnimation forKey:@"playerReadyAnimation"];
        } else if (self.player.status == AVPlayerStatusFailed) {
        }
    }
}


- (void)cleanVideoLayer
{
    [self.player pause];
    //[self.playerLayer removeFromSuperlayer];
}

- (void)checkNetworkStatus
{
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    reach.reachableBlock = ^(Reachability*reach)
    {
        isConnected = YES;
    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        isConnected = NO;
    };
    [reach startNotifier];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    isConnected = NO;
    [self checkNetworkStatus];
    self.storyBoardIdentifier = @"entranceViewController";
    [self initUI];
    [self showVideoLayer];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if(isConnected){
        return YES;
    }
    else
    {
        [[MailCatUtil singleton]displayToastMsg:@"网络尚未连接" inView:self.view afterDelay:1.3];
        return NO;
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self cleanVideoLayer];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self showIntroductionView];
    //[self.player seekToTime:CMTimeMake(25, 1)];
    [self.player play];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self showInboxICON];
}

- (IBAction)clickInboxButton:(id)sender {
    AVUser * currentUser = [AVUser currentUser];
    if (currentUser) {
        [self checkEmailVerified];
    }
    else
    {
        if (isConnected) {
            //present registration view controller with unregisted flag
            RegistrationViewController* registionViewController = (RegistrationViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"registrationViewController"];
            registionViewController.userStatus = UnRegister;
            [self presentViewController:registionViewController animated:YES completion:nil];
        }
        else
        {
            [[MailCatUtil singleton]displayToastMsg:@"网络尚未连接" inView:self.view afterDelay:1.3];
        }
    }
}


- (void)didReceiveMemoryWarning {
    NSLog(@"memory");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (BOOL)prefersStatusBarHidden
//{
//    return NO;
//}

- (void)checkEmailVerified
{
    [[MailCatUtil singleton]showLoadingView:self.view];
    [LetterUser checkUserVerfied:^(BOOL isVerified) {
        dispatch_async(dispatch_get_main_queue(),^{
            [[MailCatUtil singleton]hideLodingView];
            if (isVerified) {
                //present inbox viewcontroller
                [self presentLetterInboxVC];
            }
            else
            {
                //present registration view controller with unverified flag
                //present inbox viewcontroller
                if (isConnected) {
                    RegistrationViewController* registionViewController = (RegistrationViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"registrationViewController"];
                    registionViewController.delegate = self;
                    registionViewController.userStatus = UnVerified;
                    [self presentViewController:registionViewController animated:YES completion:nil];
                }
                else
                {
                    [[MailCatUtil singleton]displayToastMsg:@"网络尚未连接" inView:self.view afterDelay:1.3];
                }
            }
        });
    }];
}

- (void)RegistrationViewControllerDidLogIn
{
    [self presentLetterInboxVC];
}

- (void)presentLetterInboxVC
{
    if (isConnected) {
        LetterInBoxViewController* letterInboxViewController = (LetterInBoxViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"letterInboxViewController"];
        [self presentViewController:letterInboxViewController animated:YES completion:nil];
    }
    else
    {
        [[MailCatUtil singleton]displayToastMsg:@"网络尚未连接" inView:self.view afterDelay:1.3];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.introScrollView.frame.size.width; // you need to have a **iVar** with getter for scrollView
    float fractionalPage = self.introScrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    self.pageControl.currentPage = page; // you need to have a **iVar** with getter for pageControl
}



@end
