//
//  PoemDetailView.m
//  Poem
//
//  Created by Lanston Peng on 6/1/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "PoemDetailView.h"

@interface PoemDetailView()
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


@implementation PoemDetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        CALayer* shadow = [CALayer layer];
        shadow.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        shadow.shadowColor = [UIColor orangeColor].CGColor;
        shadow.shadowOffset = CGSizeMake(-5, 0);
        shadow.shadowOpacity = 0.8;
        shadow.shadowRadius = 5;
        //[self.layer addSublayer:shadow];
        
        CGRect sFrame = [UIScreen mainScreen].bounds;
        _bgMaskLayer = [CALayer layer];
        _bgMaskLayer.opacity = 0.8;
        _bgMaskLayer.frame = CGRectMake(0, 0, frame.size.width, sFrame.size.height);
        //_bgMaskLayer.frame = self.frame;
        _bgMaskLayer.backgroundColor = UIColorFromRGB(0xf1f1f1).CGColor;
        self.clipsToBounds = NO;
        [self.layer addSublayer:_bgMaskLayer];
        [self initPoemView];
    }
    return self;
}
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
- (void)requestPoem:(void (^)(NSDictionary* poem))successCallback fail:(void (^)())failCallback
{
    NSDictionary* poemJSON =
  @{
    @"title":@"Shall I compare thee to a summer's day?",
    @"author":@"William Shakespeare",
    @"bgimg":@"Shakespeare",
    @"id":@101,
    @"body":@[@"Shall I compare thee to a summer's day?",
              @"能不能让我来把你比拟做夏日?",
              
              @"Thou art more lovely and more temperate",
              @"你可是更加温和,更加可爱",
              
              @"Rough winds do shake the darling buds of May",
              @"狂风会吹落五月里开的好花儿",
              
              @"And summer's lease hath all too short a date",
              @"夏季的生命又未免结束得太快",
              
              @"Sometimes too hot the eys of heaven shines",
              @"有时候苍天的巨眼照得太灼热",
              
              @"And often is his gold complexion dimmed",
              @"他那金彩的脸色也会被遮暗",
              
              @"And every fair from fair somethme declines",
              @"每一样美呀,总会离开美而凋落",
              
              @"By chance, or nature's changing course, untrimmed",
              @"被时机或者自然的代谢所摧残",
              
              @"But thy eternal summer shall not fade",
              @"但是你永久的夏天决不会凋枯",
              
              @"Nor lose possession of that fair thou owest",
              @"你永远不会失去你美的仪态",
              
              @"Nor shall Death brag thou wanderest in his shade",
              @"死神夸不着你在他的影子里踯躅",
              
              @"When in eternal lines to time thou growest.",
              @"你将在不朽的诗中与时间同在",
              
              @"So long as men can breathe or eyes can see",
              @"只要人类在呼吸,眼睛看得见",
              
              @"So long lives this, and this gives life to thee",
              @"我这诗就活着,使你的生命绵延"
              ]
    };
    if (successCallback) {
        successCallback(poemJSON);
    }
    //return poemJSON;
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
    
    self.userInteractionEnabled = NO;
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
        self.userInteractionEnabled = YES;
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
-(void)handleSwipeRightGesture:(id)sender
{
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
    
    self.userInteractionEnabled = NO;
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
        self.userInteractionEnabled = YES;
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
- (void)initPoemView
{
    [self initSystemConfiguration];
    UISwipeGestureRecognizer* swipeUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeUpGesture:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    UISwipeGestureRecognizer* swipeDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeDownGesture:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self addGestureRecognizer:swipeUp];
    [self addGestureRecognizer:swipeDown];
    [self addSubview:self.currentLineOfPoemLabel];
    [self addSubview:self.alternativeLinePoemLabel];
    [self addSubview:self.translatedLabel];
    
    UITapGestureRecognizer* tapLine1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
    UITapGestureRecognizer* tapLine2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
    _currentLineOfPoemLabel.userInteractionEnabled = YES;
    _alternativeLinePoemLabel.userInteractionEnabled = YES;
    [_currentLineOfPoemLabel addGestureRecognizer:tapLine1];
    [_alternativeLinePoemLabel addGestureRecognizer:tapLine2];
    
    UISwipeGestureRecognizer* swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeRightGesture:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swipeRight];
    
    //self.backgroundColor = UIColorFromRGB(0xf1f1f1);
    
    [self requestPoem:^(NSDictionary *poem) {
        poemLines = poem[@"body"];
        totalLine = (int)poemLines.count;
        currentLine = 0;
        
        _currentLineOfPoemLabel.text = [self getCurrentLine];
        
        //NSString* titleStr = poem[@"title"];
        //NSString* authorStr = poem[@"author"];
        
    } fail: ^{}];
    
    
    //Full Screen
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
