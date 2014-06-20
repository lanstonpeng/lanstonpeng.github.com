//
//  ViewController.m
//  LineSum
//
//  Created by Lanston Peng on 4/17/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "ViewController.h"
#import "MatrixMath.h"
#define GRID_HEIGHT 4
#define UP_PADDING 10
#define CUBE_WIDTH 80
#define CUBE_LINE_COUNT 4
#define CUBE_COUNT 3

//Game Cube Value
#define CUBE_VALUE_MAX 9
#define CUBE_SELECTED_COLOR 0xFF6B6B

@interface ViewController ()<ScoreTargetDelgate,TimeBarDelegate,CubeContainerDelegate>

@property (strong,nonatomic)NSArray* sequence;
@property (nonatomic)NSUInteger sum;
@property (strong,nonatomic)ScoreBoardView* scoreBoardView;
@property (strong,nonatomic)UILabel* sumLabel;
@property (strong,nonatomic)TimeBarView* timeBar;
@property (strong,nonatomic)NSTimer* timeBarTimer;
@property (strong,nonatomic)CubeContainerView* cubeContainerView;
@property (strong,nonatomic)UIButton* restartBtn;
@property (strong,nonatomic)UILabel* msgBox;
@property (strong,nonatomic)UILabel* currentScore;
@end


@implementation ViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSDictionary* dic = [Util generateNumbers:CUBE_COUNT];
    self.sequence = [dic objectForKey:@"sequence"];
    self.sum = [(NSNumber*)[dic objectForKey:@"sum"] integerValue];
    
    [self initGameUI];
    
    self.scoreBoardView = [[ScoreBoardView alloc]initScoreBoradView:(int)_sum
                                                       withDelegate:self];
    //Text Label
    self.sumLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, 80, 40)];
    self.sumLabel.text = [[dic objectForKey:@"sum"] stringValue];
    [self.view addSubview:self.sumLabel];
    
    
    self.msgBox = [[UILabel alloc]initWithFrame:CGRectMake(IPHONE_SCREEN_WIDTH - 200, 50, 100, 40)];
    self.msgBox.textAlignment = NSTextAlignmentCenter;
    self.msgBox.backgroundColor = [Util generateColor];
    [self.view addSubview:self.msgBox];
    
    CGRect frame = CGRectMake(0, 100, IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_HEIGHT);
    self.cubeContainerView = [[CubeContainerView alloc]initWithFrame:frame withSolutionDic:dic andScoreView:self.scoreBoardView];
    self.cubeContainerView.delegate = self;
    [self.view addSubview:self.cubeContainerView];
    [self.view addSubview:self.scoreBoardView];
    
    [self prepareTimer];
    
    //Full Screen
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
    NSArray* arr = @[
                     @2,@9,@5,@6,@1,
                     @4,@9,@6,@7,@8,
                     @9,@8,@1,@2,@2,
                     @4,@7,@1,@9,@4,
                     ];
    MatrixMath* matrixMath = [[MatrixMath alloc] initWithArray:arr andSize:CGSizeMake(5, 4)];
    [matrixMath isSumExist:10];
}
-(void)initGameUI{
    
    self.timeBar = [[TimeBarView alloc]init];
    self.timeBar.backgroundColor = [Util generateColor];
    self.timeBar.delegate =self;
    [self.view addSubview:self.timeBar];
    
    self.restartBtn = [[UIButton alloc]initWithFrame:CGRectMake(IPHONE_SCREEN_WIDTH - 100, 50, 100, 40)];
    [self.restartBtn setTitle:@"Restart" forState:UIControlStateNormal];
    self.restartBtn.backgroundColor = [Util generateColor];
    self.scoreBoardView.backgroundColor = [Util generateColor];
    
    [self.view addSubview:self.scoreBoardView];
    [self.view addSubview:self.restartBtn];
    
    UITapGestureRecognizer* restartTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(restartGame)];
    [self.restartBtn addGestureRecognizer:restartTap];
}
-(void)restartGame
{
    NSDictionary* dic = [Util generateNumbers:CUBE_COUNT];
    self.sequence = [dic objectForKey:@"sequence"];
    self.sum = [(NSNumber*)[dic objectForKey:@"sum"] integerValue];
    self.sumLabel.text = [[dic objectForKey:@"sum"] stringValue];
    [self.cubeContainerView removeFromSuperview];
    
    self.scoreBoardView.targetSum = (int)self.sum;
    [self.scoreBoardView resetNum];
    CGRect frame = CGRectMake(0, 100, IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_HEIGHT);
    self.cubeContainerView = [[CubeContainerView alloc]initWithFrame:frame withSolutionDic:dic andScoreView:self.scoreBoardView];
    self.cubeContainerView.delegate = self;
    [self.view addSubview:self.cubeContainerView];
    
    
    [self.timeBarTimer invalidate];
    [self prepareTimer];
}

-(void)showMessage:(NSString*)title withMsg:(NSString*)msg{
    /*
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:title
                                                      message:msg
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    
    [message show];
     */
    self.msgBox.text = msg;
}

#pragma ScoreBoard delegate
- (void)onScoreBigger{
    [self showMessage:@"Oops" withMsg:@"Too Big"];
    [self.cubeContainerView revertAllCubePath];
    [self.scoreBoardView resetNum];
    //self.timeBar.percentage = 1.0;
    //[self restartGame];
}
- (void)onScoreEqual{
    [self showMessage:@"Yep" withMsg:@"You Win"];
    [self.timeBar addProgressByPersentage:0.15f];
    [self restartGame];
}

-(void)prepareTimer{
    self.timeBar.frame = CGRectMake(0, 0, IPHONE_SCREEN_WIDTH * self.timeBar.percentage, 10);
    self.timeBarTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(dropProgress) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:self.timeBarTimer forMode:NSDefaultRunLoopMode];
}
-(void)onCubeContainerPanGestureEndWithLessScore{
    [self showMessage:@"Nope" withMsg:@"Too Small"];
}

#pragma time bar delegate
-(void)onTimesUp{
    [self.timeBarTimer invalidate];
    [self showMessage:@"Oops" withMsg:@"Time's Up"];
    self.timeBar.percentage = 1.0;
    [self restartGame];
}

#pragma drop progress timer
-(void)dropProgress
{
    [self.timeBar dropProgressByPersentage:0.005];
    if(self.timeBar.percentage <= 0.88f && !self.cubeContainerView.hasTapOnContainer){
        self.cubeContainerView.hasTapOnContainer = YES;
        [self.cubeContainerView giveAHint];
    }
}
//FIXME: touchBegan的时候开始积分
//TODO: decouple message Box functionality
//TODO: change the cube UI to dot UI
//TODO: add level feature
@end
