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

@interface EntranceViewController ()


@property (strong, nonatomic) UIImageView *paperImageView;

@property (weak, nonatomic) IBOutlet UIImageView *folderImageView;

@property (strong,nonatomic)UIAttachmentBehavior* attachmentBehavior;

@property (strong,nonatomic)UIDynamicAnimator* animator;
@property (weak, nonatomic) IBOutlet UIButton *prepareWritingBtn;

@property (weak, nonatomic) IBOutlet UIScrollView *introScrollView;

@property (strong,nonatomic)AVPlayer* player;

@property (strong,nonatomic)AVPlayerLayer *playerLayer;
@end


@implementation EntranceViewController
{
    //CGFloat startPanY;
    CGRect paperImageViewOriginalFrame;
}

- (IBAction)showSideMenu:(id)sender {
}

- (void)initUI
{
    self.prepareWritingBtn.layer.cornerRadius = 4;
    self.prepareWritingBtn.layer.borderWidth = 0.5;
    self.prepareWritingBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.paperImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"paper"]];
    self.paperImageView.contentMode = UIViewContentModeScaleAspectFill;
    //[self.view insertSubview:self.paperImageView belowSubview:self.folderImageView];
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
    
    NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"Remember to Write-HD" ofType:@"mp4"];
    NSURL* url = [NSURL fileURLWithPath:videoPath];
    self.player = [AVPlayer playerWithURL:url]; //
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
    
    CALayer* shadowLayer = [CALayer layer];
    shadowLayer.frame = self.view.bounds;
    shadowLayer.backgroundColor = [UIColor blackColor].CGColor;
    shadowLayer.opacity = 0.4;
    [self.view.layer insertSublayer:_playerLayer atIndex:0];
    [self.view.layer insertSublayer:shadowLayer above:_playerLayer];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
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
    self.animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self cleanVideoLayer];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self showIntroductionView];
    [self.player play];
}
- (void)viewWillAppear:(BOOL)animated
{
    CGRect folderFrame = self.folderImageView.frame;
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    paperImageViewOriginalFrame = CGRectMake(screenBounds.size.width * 0.1,
                                             folderFrame.origin.y - screenBounds.size.height * 0.01,
                                             screenBounds.size.width * 0.8,
                                             screenBounds.size.height * 0.2);
    _paperImageView.frame = paperImageViewOriginalFrame;
    [self showVideoLayer];
}

- (IBAction)handlePanUpGesture:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint paperLocation = [recognizer locationInView:self.paperImageView];
    CGPoint viewLocation  = [recognizer locationInView:self.view];
    self.attachmentBehavior.anchorPoint = [recognizer locationInView:self.view];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        //UIDynamic
        [self.animator removeAllBehaviors];
       
        UIOffset centerOffset = UIOffsetMake(paperLocation.x - CGRectGetMidX(self.paperImageView.bounds), paperLocation.y - CGRectGetMidY(self.paperImageView.bounds));
        
        self.attachmentBehavior = [[UIAttachmentBehavior alloc]initWithItem:self.paperImageView offsetFromCenter:centerOffset attachedToAnchor:viewLocation];
        [self.animator addBehavior:self.attachmentBehavior];
    }
    else if(recognizer.state == UIGestureRecognizerStateChanged)
    {
        self.attachmentBehavior.anchorPoint = viewLocation;
    }
    else if(recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled)
    {
        [self.animator removeAllBehaviors];
        CGPoint point = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(paperImageViewOriginalFrame));
        UISnapBehavior* snapBehavior = [[UISnapBehavior alloc]initWithItem:self.paperImageView snapToPoint:point];
        [self.animator addBehavior:snapBehavior];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
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
