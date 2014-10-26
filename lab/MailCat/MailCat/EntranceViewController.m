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

@interface EntranceViewController ()<RegistrationViewControllerDelegate>


@property (weak, nonatomic) IBOutlet UIButton *prepareWritingBtn;

@property (weak, nonatomic) IBOutlet UIScrollView *introScrollView;

@property (strong,nonatomic)AVPlayer* player;

@property (strong,nonatomic)AVPlayerLayer *playerLayer;
@end


@implementation EntranceViewController
{
    CALayer* shadowLayer;
}
- (IBAction)showSideMenu:(id)sender {
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
    introView1.titleLabel.text = @"Welcome";
    introView1.contentLabel.text = @"I can't figure why I cannot resize a UIView in a xib in Interface Builder. ... view XIB in xcode and in the size inspector, the width and height are";
    
    NSArray* arr2 = [[NSBundle mainBundle]loadNibNamed:@"introductionView" owner:nil options:nil];
    introductionView* introView2 = (introductionView*)[arr2 firstObject];
    introView2.titleLabel.text = @"Welcome";
    introView2.contentLabel.text = @"I can't figure why I cannot resize a UIView in a xib in Interface Builder. ... view XIB in xcode and in the size inspector, the width and height are";
    
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
    NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"begin" ofType:@"mp4"];
    NSURL* url = [NSURL fileURLWithPath:videoPath];
    NSLog(@"%@",url);
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
    [self.playerLayer removeFromSuperlayer];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.storyBoardIdentifier = @"entranceViewController";
    [self initUI];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self cleanVideoLayer];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self showIntroductionView];
    [self.player seekToTime:CMTimeMake(25, 1)];
    [self.player play];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self showVideoLayer];
}

- (IBAction)clickInboxButton:(id)sender {
    AVUser * currentUser = [AVUser currentUser];
    if (currentUser) {
        [self checkEmailVerified];
    }
    else
    {
        //present registration view controller with unregisted flag
        RegistrationViewController* registionViewController = (RegistrationViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"registrationViewController"];
        registionViewController.userStatus = UnRegister;
        [self presentViewController:registionViewController animated:YES completion:nil];
    }
}


- (void)didReceiveMemoryWarning {
    NSLog(@"memory");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

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
                RegistrationViewController* registionViewController = (RegistrationViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"registrationViewController"];
                registionViewController.delegate = self;
                registionViewController.userStatus = UnVerified;
                [self presentViewController:registionViewController animated:YES completion:nil];
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
    LetterInBoxViewController* letterInboxViewController = (LetterInBoxViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"letterInboxViewController"];
    [self presentViewController:letterInboxViewController animated:YES completion:nil];
}

@end
