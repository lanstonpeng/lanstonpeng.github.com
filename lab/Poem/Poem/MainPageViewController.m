//
//  MainPageViewController.m
//  Poem
//
//  Created by Lanston Peng on 5/30/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "MainPageViewController.h"
#import "ContainerViewController.h"

@interface MainPageViewController ()//<UIGestureRecognizerDelegate>
{
    float screenHeight;
    float screenWidth;
    int totalLine;
    int currentLine;
    
    //one poem data,divided into lines
    NSArray* poemLines;
    
    UILabel* titleLabel;
    UILabel* authorLabel;
    
    BOOL isShowingTranslatedLabel;
}

@property (strong,nonatomic) UILabel* currentLineOfPoemLabel;
@property (strong,nonatomic) UILabel* alternativeLinePoemLabel;
@property (strong,nonatomic) UILabel* translatedLabel;

@end

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//#define PoemFont @"HelveticaNeue-Thin"
#define PoemFont @"GillSans-LightItalic"
#define ChineseFont @"STHeitiSC-Light"
#define PoemFontSize 20

#define LabelPaddLeft 10

@implementation MainPageViewController
- (UILabel *)translatedLabel
{
    if(!_translatedLabel)
    {
        CGRect f = self.currentLineOfPoemLabel.frame;
        _translatedLabel = [[UILabel alloc]initWithFrame:CGRectMake(f.origin.x, f.origin.y, f.size.width, f.size.height)];
        _translatedLabel.textAlignment = NSTextAlignmentCenter;
        _translatedLabel.alpha = 0;
        _translatedLabel.font = [UIFont fontWithName:ChineseFont size:12];
    }
    return _translatedLabel;
}
- (UILabel *)currentLineOfPoemLabel
{
    if(!_currentLineOfPoemLabel)
    {
        _currentLineOfPoemLabel  = [[UILabel alloc]initWithFrame:CGRectMake(LabelPaddLeft, screenHeight/2 - 50 , screenWidth, 50)];
        [self setLabelAttribute:_currentLineOfPoemLabel];
    }
    return _currentLineOfPoemLabel;
}

- (UILabel *)alternativeLinePoemLabel
{
    if(!_alternativeLinePoemLabel)
    {
        _alternativeLinePoemLabel  = [[UILabel alloc]initWithFrame:CGRectMake(LabelPaddLeft, screenHeight/2 - 50 , screenWidth, 50)];
        [self setLabelAttribute:_alternativeLinePoemLabel];
    }
    return _alternativeLinePoemLabel;
}

-(void)initSystemConfiguration
{
    CGRect f = [UIScreen mainScreen].bounds;
    screenHeight = f.size.height;
    screenWidth = f.size.width - 20 ;
}
-(NSString*)getCurrentLine
{
    NSString* line =  poemLines[currentLine];
    return line;
}
-(NSString*)getNextLine
{
    currentLine+=2;
    NSString* line =  poemLines[currentLine];
    return line;
}
-(NSString*)getPrevLine
{
    currentLine-=2;
    NSString* line =  poemLines[currentLine];
    return line;
}
-(void)showWholePoem
{
    
}
-(void)setLabelAttribute:(UILabel*)label
{
    //label.textColor = UIColorFromRGB(0xFF874F);
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.font = [UIFont fontWithName:PoemFont size:PoemFontSize];
}
-(void)configureChineseLabel:(UILabel*)label
{
    
}
-(void)handleSwipeDownGesture:(id)sender
{
    
    //since it's the first line,disable it
    if(currentLine == 0){
        return;
    }
    _alternativeLinePoemLabel.frame = CGRectMake(LabelPaddLeft, screenHeight/2 - 100 , screenWidth, 50);
    _alternativeLinePoemLabel.alpha = 0;
    
    [self setLabelAttribute:_alternativeLinePoemLabel];
    
    _alternativeLinePoemLabel.text = [self getPrevLine];
    
    self.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect f = _currentLineOfPoemLabel.frame;
        _currentLineOfPoemLabel.frame = CGRectMake(f.origin.x, f.origin.y + 50, f.size.width, f.size.height);
        _currentLineOfPoemLabel.alpha = 0;
        
        _alternativeLinePoemLabel.frame = CGRectMake(LabelPaddLeft, screenHeight/2 - 50 , screenWidth, 50);
        _alternativeLinePoemLabel.alpha = 1;
    } completion:^(BOOL finished) {
        id temp = _currentLineOfPoemLabel;
        _currentLineOfPoemLabel = _alternativeLinePoemLabel;
        _alternativeLinePoemLabel = temp;
        self.view.userInteractionEnabled = YES;
    }];
    
    if(isShowingTranslatedLabel)
    {
        _translatedLabel.text = poemLines[currentLine + 1];
        _translatedLabel.alpha = 0;
        [UIView animateWithDuration:0.2 delay:0.4 options:UIViewAnimationOptionCurveEaseIn animations:^{
           _translatedLabel.alpha = 1;
       } completion:^(BOOL finished) {
       }];
    }
}
-(void)handleSwipeLeftGesture:(id)sender
{
    //[[ContainerViewController sharedViewController]popViewController];
    NSLog(@"ASDF");
}
-(void)handleSwipeUpGesture:(id)sender
{
    if(currentLine == totalLine - 2){
        return;
    }
    _alternativeLinePoemLabel.frame = CGRectMake(LabelPaddLeft, screenHeight/2 , screenWidth, 50);
    _alternativeLinePoemLabel.alpha = 0;
    [self setLabelAttribute:_alternativeLinePoemLabel];
    _alternativeLinePoemLabel.text = [self getNextLine];
    
    self.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGRect f = _currentLineOfPoemLabel.frame;
        _currentLineOfPoemLabel.frame = CGRectMake(f.origin.x, f.origin.y - 50, f.size.width, f.size.height);
        _currentLineOfPoemLabel.alpha = 0;
        
        _alternativeLinePoemLabel.frame = CGRectMake(LabelPaddLeft, screenHeight/2 - 50 , screenWidth, 50);
        _alternativeLinePoemLabel.alpha = 1;
    } completion:^(BOOL finished) {
        id temp = _currentLineOfPoemLabel;
        _currentLineOfPoemLabel = _alternativeLinePoemLabel;
        _alternativeLinePoemLabel = temp;
        self.view.userInteractionEnabled = YES;
    }];
    
    if(isShowingTranslatedLabel)
    {
       [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
           _translatedLabel.alpha = 0;
       } completion:^(BOOL finished) {
           _translatedLabel.text = poemLines[currentLine + 1];
           [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
               _translatedLabel.alpha = 1;
           } completion:^(BOOL finished) {
           }];
       }];
    }
}
- (void)handleTapGesture:(id)sender
{
    CGRect f = _currentLineOfPoemLabel.frame;
    if(isShowingTranslatedLabel){
        
        [UIView animateWithDuration:0.2 animations:^{
            //_translatedLabel.frame = CGRectMake(f.origin.x, f.origin.y - f.size.height, f.size.width, f.size.height);
            _translatedLabel.alpha = 0;
        } completion:^(BOOL finished) {
            isShowingTranslatedLabel = NO;
        }];
        return;
    }
    _translatedLabel.frame = CGRectMake(f.origin.x, f.origin.y, f.size.width, f.size.height);
    _translatedLabel.text = poemLines[currentLine + 1];
    
    [UIView animateWithDuration:0.2 animations:^{
        _translatedLabel.frame = CGRectMake(f.origin.x, f.origin.y + f.size.height, f.size.width, f.size.height);
        _translatedLabel.alpha = 1;
    } completion:^(BOOL finished) {
        isShowingTranslatedLabel = YES;
    }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initSystemConfiguration];
    UISwipeGestureRecognizer* swipeUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeUpGesture:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    UISwipeGestureRecognizer* swipeDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeDownGesture:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeUp];
    [self.view addGestureRecognizer:swipeDown];
    [self.view addSubview:self.currentLineOfPoemLabel];
    [self.view addSubview:self.alternativeLinePoemLabel];
    [self.view addSubview:self.translatedLabel];
    
    UITapGestureRecognizer* tapLine1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
    UITapGestureRecognizer* tapLine2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
    _currentLineOfPoemLabel.userInteractionEnabled = YES;
    _alternativeLinePoemLabel.userInteractionEnabled = YES;
    [_currentLineOfPoemLabel addGestureRecognizer:tapLine1];
    [_alternativeLinePoemLabel addGestureRecognizer:tapLine2];
    
    UISwipeGestureRecognizer* swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeLeftGesture:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    
    self.view.backgroundColor = UIColorFromRGB(0xf1f1f1);
    
    
    //Full Screen
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
