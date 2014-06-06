//
//  PoemDetailView.m
//  Poem
//
//  Created by Lanston Peng on 6/1/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "PoemDetailView.h"
#import "UIImage+PoemResouces.h"
#import "PoemExplanationView.h"
#import "PoemLineView.h"


@interface PoemDetailView()<UITextViewDelegate>
{
    float screenHeight;
    float screenWidth;
    int totalLine;
    int currentLine;
    
    //one poem data,divided into lines
    NSArray* poemLines;
    NSDictionary* poemDic;
    
    UILabel* titleLabel;
    UILabel* authorLabel;
    
    
    BOOL isShowingTranslatedLabel;
}

/*
@property (strong,nonatomic) UITextView* currentLineOfPoemTextView;
@property (strong,nonatomic) UITextView* alternativeLinePoemTextView;
@property (strong,nonatomic) UITextView* translatedTextView;
*/
@property (strong,nonatomic) UIImageView* backgroundImageView;
@property (strong,nonatomic) UIScrollView* backgroundScrollView;
@property (strong,nonatomic) PoemExplanationView* explanationView;
@property (strong,nonatomic) PoemLineView* currentLineOfPoemTextView;
@property (strong,nonatomic) PoemLineView* alternativeLinePoemTextView;
@property (strong,nonatomic) PoemLineView* translatedTextView;

@end

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//#define PoemFont @"HelveticaNeue-Thin"
#define PoemFont @"GillSans-LightItalic"
//#define ChineseFont @"STHeitiSC-Light"
#define ChineseFont @"FZQKBYSJW--GB1-0"

#define PoemFontSize 20

#define LabelPaddLeft 10

#define PoemTextViewHeight 60

//a little bit higher for displaying the translated text
static CGRect currentLineFrame;

@implementation PoemDetailView

- (void)setPoemData:(NSDictionary *)poemData
{
    poemLines = poemData[@"poembody"];
    poemDic = poemData;
    _currentTranslatedLanguage = @"chinese";
    if(self.explanationView.frame.origin.y == 0)
    {
        self.explanationView.frame = CGRectOffset(self.explanationView.frame, 0, -self.explanationView.frame.size.height);
    }
    //[self initPoemView];
    [self initPoemData];
}
- (id)initWithFrame:(CGRect)frame  withData:(NSDictionary*)poem
{
    poemLines = poem[@"poembody"];
    poemDic = poem;
    _currentTranslatedLanguage = @"chinese";
    return [self initWithFrame:frame];
}
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
       
        _backgroundImageView = [[UIImageView alloc]initWithImage: (UIImage*)[[UIImage alloc]initWithName:@"paisaje_azul_1920x1200"]];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImageView.frame = shadow.frame;
        _backgroundImageView.clipsToBounds = YES;
        //[self addSubview:_backgroundImageView];
        self.clipsToBounds = NO;
        //[self.layer addSublayer:_bgMaskLayer];
        [self initPoemView];
    }
    return self;
}
- (UIScrollView *)backgroundScrollView
{
    if(!_backgroundScrollView)
    {
        _backgroundScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screenWidth + 20, screenHeight)];
        //_backgroundScrollView.contentSize = CGSizeMake( (screenWidth + 20)+1, 0);
        //_backgroundScrollView.bounces = YES;
        _backgroundScrollView.alwaysBounceHorizontal = YES;
        _backgroundScrollView.canCancelContentTouches = NO;
    }
    return _backgroundScrollView;
}
- (PoemExplanationView *)explanationView
{
    if(!_explanationView)
    {
        _explanationView = [[PoemExplanationView alloc]initWithFrame:CGRectMake(0, -130, 320, 130) withExplanation:@""];
    }
    return _explanationView;
}
- (PoemLineView*)translatedTextView
{
    if(!_translatedTextView)
    {
        CGRect f = self.currentLineOfPoemTextView.frame;
        _translatedTextView = [[PoemLineView alloc]initWithFrame:CGRectMake(f.origin.x, f.origin.y, f.size.width, f.size.height)];
        _translatedTextView.textAlignment = NSTextAlignmentCenter;
        _translatedTextView.backgroundColor = [UIColor clearColor];
        _translatedTextView.alpha = 0;
        _translatedTextView.editable = NO;
        UIFont* font = [UIFont fontWithName:ChineseFont size:14];
        /*
         NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
        NSArray *fontNames;
        
        NSInteger indFamily, indFont;
        
        for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
        {
            NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
            
            fontNames = [[NSArray alloc] initWithArray:
                         
                         [UIFont fontNamesForFamilyName:
                          
                          [familyNames objectAtIndex:indFamily]]];
            
            for (indFont=0; indFont<[fontNames count]; ++indFont)
                
            {
                
                NSLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);
                
            }
        }*/
        _translatedTextView.font = font;
    }
    return _translatedTextView;
}
- (PoemLineView *)currentLineOfPoemTextView
{
    if(!_currentLineOfPoemTextView)
    {
        _currentLineOfPoemTextView  = [[PoemLineView alloc]initWithFrame:currentLineFrame];
        _currentLineOfPoemTextView.scrollEnabled = NO;
        _currentLineOfPoemTextView.backgroundColor = [UIColor clearColor];
        _currentLineOfPoemTextView.editable = NO;
        _currentLineOfPoemTextView.userInteractionEnabled = NO;
        //[self setLabelAttribute:_currentLineOfPoemTextView];
    }
    return _currentLineOfPoemTextView;
}

- (PoemLineView *)alternativeLinePoemTextView
{
    if(!_alternativeLinePoemTextView)
    {
        _alternativeLinePoemTextView  = [[PoemLineView alloc]initWithFrame:CGRectMake(LabelPaddLeft, screenHeight, screenWidth, PoemTextViewHeight)];
        _alternativeLinePoemTextView.delegate = self;
        _alternativeLinePoemTextView.scrollEnabled = NO;
        _alternativeLinePoemTextView.backgroundColor = [UIColor clearColor];
        _alternativeLinePoemTextView.editable = NO;
        _alternativeLinePoemTextView.userInteractionEnabled = NO;
        //[self setLabelAttribute:_alternativeLinePoemTextView];
    }
    return _alternativeLinePoemTextView;
}

-(void)initSystemConfiguration
{
    CGRect f = [UIScreen mainScreen].bounds;
    screenHeight = f.size.height;
    screenWidth = f.size.width - 20 ;
    currentLineFrame = CGRectMake(LabelPaddLeft, screenHeight/2 - PoemTextViewHeight , screenWidth, PoemTextViewHeight);
}
-(NSString*)getCurrentLine
{
   // NSString* line =  poemLines[currentLine][@"text"];
    
    NSDictionary* currentLineDic = [self getCurrentLineDictionary];
    NSString* line =  currentLineDic[@"text"];
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc]initWithString:line];
    if (currentLineDic[@"explanation"]) {
        [currentLineDic[@"explanation"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSLog(@"--> %@",key);
            [attrString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x01C9FF) range:[line rangeOfString:key]];
        }];
    }
    return [attrString string];
}
-(void)setUpAttributeString:(NSMutableAttributedString*)attrStr
{
    NSRange range = NSMakeRange(0, [attrStr string].length);
    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:PoemFont size:PoemFontSize] range:range];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
    NSMutableParagraphStyle *paragrapStyle = [[NSMutableParagraphStyle alloc] init];
    paragrapStyle.alignment = NSTextAlignmentCenter;
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragrapStyle range:range];
}
-(NSMutableAttributedString*)getCurrentAttributeString
{
    
    NSDictionary* currentLineDic = [self getCurrentLineDictionary];
    NSString* line =  currentLineDic[@"text"];
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc]initWithString:line];
    [self setUpAttributeString:attrString];
    if (currentLineDic[@"explanation"]) {
        [currentLineDic[@"explanation"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [attrString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x0097FF) range:[line rangeOfString:key]];
        }];
    }
    return attrString;
}
-(NSDictionary*)getCurrentLineDictionary
{
    return poemLines[currentLine];
}
-(NSMutableAttributedString*)getNextLineAttributeString
{
    currentLine++;
    return [self getCurrentAttributeString];
}
-(NSMutableAttributedString*)getPrevLineAttributeString
{
    currentLine--;
    return [self getCurrentAttributeString];
}
-(void)setLabelAttribute:(UITextView*)textView
{
    //label.textColor = UIColorFromRGB(0xFF874F);
    textView.backgroundColor = [UIColor clearColor];
    textView.textColor = [UIColor blackColor];
    textView.textAlignment = NSTextAlignmentCenter;
    //label.numberOfLines = 0;
    textView.font = [UIFont fontWithName:PoemFont size:PoemFontSize];
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
    [self hideExplanationView];
    _alternativeLinePoemTextView.frame = CGRectMake(LabelPaddLeft, screenHeight/2 - 2*PoemTextViewHeight , screenWidth, PoemTextViewHeight);
    _alternativeLinePoemTextView.alpha = 0;
    
    //[self setLabelAttribute:_alternativeLinePoemTextView];
    
    _alternativeLinePoemTextView.attributedText = [self getPrevLineAttributeString];
    
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect f = _currentLineOfPoemTextView.frame;
        _currentLineOfPoemTextView.frame = CGRectMake(f.origin.x, f.origin.y + 50, f.size.width, f.size.height);
        _currentLineOfPoemTextView.alpha = 0;
        
        _alternativeLinePoemTextView.frame = CGRectMake(LabelPaddLeft, screenHeight/2 - PoemTextViewHeight , screenWidth, PoemTextViewHeight);
        _alternativeLinePoemTextView.alpha = 1;
    } completion:^(BOOL finished) {
        id temp = _currentLineOfPoemTextView;
        _currentLineOfPoemTextView = _alternativeLinePoemTextView;
        _alternativeLinePoemTextView = temp;
        self.userInteractionEnabled = YES;
    }];
    
    if(isShowingTranslatedLabel)
    {
        _translatedTextView.text = poemLines[currentLine][@"translated"][_currentTranslatedLanguage];
        _translatedTextView.alpha = 0;
        [UIView animateWithDuration:0.2 delay:0.4 options:UIViewAnimationOptionCurveEaseIn animations:^{
           _translatedTextView.alpha = 1;
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
    [self hideExplanationView];
    _alternativeLinePoemTextView.frame = CGRectMake(LabelPaddLeft, screenHeight/2 , screenWidth, PoemTextViewHeight);
    _alternativeLinePoemTextView.alpha = 0;
    //[self setLabelAttribute:_alternativeLinePoemTextView];
    _alternativeLinePoemTextView.attributedText = [self getNextLineAttributeString];
    
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGRect f = _currentLineOfPoemTextView.frame;
        _currentLineOfPoemTextView.frame = CGRectMake(f.origin.x, f.origin.y - 50, f.size.width, f.size.height);
        _currentLineOfPoemTextView.alpha = 0;
        _alternativeLinePoemTextView.frame = CGRectMake(LabelPaddLeft, screenHeight/2 - PoemTextViewHeight , screenWidth, PoemTextViewHeight);
        _alternativeLinePoemTextView.alpha = 1;
    } completion:^(BOOL finished) {
        id temp = _currentLineOfPoemTextView;
        _currentLineOfPoemTextView = _alternativeLinePoemTextView;
        _alternativeLinePoemTextView = temp;
        self.userInteractionEnabled = YES;
    }];
    
    if(isShowingTranslatedLabel)
    {
       [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
           _translatedTextView.alpha = 0;
       } completion:^(BOOL finished) {
           _translatedTextView.text = poemLines[currentLine][@"translated"][_currentTranslatedLanguage];
           [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
               _translatedTextView.alpha = 1;
           } completion:^(BOOL finished) {
           }];
       }];
    }
}
- (void)handleTapGesture:(UITapGestureRecognizer *)sender
{
    CGPoint pos = [sender locationInView:sender.view];
     UITextView *tv = (UITextView*)sender.view;
    
     //eliminate scroll offset
     pos.y += tv.contentOffset.y;
     
     //get location in text from textposition at point
     UITextPosition *tapPos = [tv closestPositionToPoint:pos];
     
     //fetch the word at this position (or nil, if not available)
     UITextRange * wr = [tv.tokenizer rangeEnclosingPosition:tapPos withGranularity:UITextGranularityWord inDirection:UITextLayoutDirectionRight];
     
    NSString* tapWord = [tv textInRange:wr];
    NSDictionary* explainDic = [self getCurrentLineDictionary][@"explanation"];
    if(tapWord && explainDic )
    {
        if(explainDic[tapWord])
        {
            //NSLog(@"%@",explainDic[tapWord]);
            [self showExplanationView:explainDic[tapWord]];
        }
    }
}
- (void)showExplanationView:(NSString*)explanationStr
{
    self.explanationView.explanationData = explanationStr;
    //is close
    if(self.explanationView.frame.origin.y == -self.explanationView.frame.size.height)
    {
        [UIView animateWithDuration:0.4 animations:^{
            self.explanationView.frame = CGRectOffset(self.explanationView.frame, 0, self.explanationView.frame.size.height);
        } completion:^(BOOL finished) {
        }];
    }
}
- (void)hideExplanationView
{
    
    //is open
    if(self.explanationView.frame.origin.y == 0)
    {
        [UIView animateWithDuration:0.4 animations:^{
            self.explanationView.frame = CGRectOffset(self.explanationView.frame, 0, -self.explanationView.frame.size.height);
        } completion:^(BOOL finished) {
        }];
    }
}
- (void)initBackgroundImageViewAnimation
{
    CABasicAnimation* animation = [CABasicAnimation animation];
    animation.keyPath = @"position.x";
    animation.fromValue = @(_backgroundImageView.frame.origin.x);
    animation.toValue = @(_backgroundImageView.frame.origin.x + 100);
    animation.duration = 20;
    [_backgroundImageView.layer addAnimation:animation forKey:@"basic"];
    _backgroundScrollView.layer.position = CGPointMake(_backgroundScrollView.frame.origin.x + 100, 0);
}
- (void)initPoemData
{
    totalLine = (int)poemLines.count;
    currentLine = 0;
    _currentLineOfPoemTextView.frame = currentLineFrame;
    //hide it
    _alternativeLinePoemTextView.frame = CGRectMake(LabelPaddLeft, screenHeight, screenWidth, PoemTextViewHeight);
    //_currentLineOfPoemTextView.text = [self getCurrentLine];
    _currentLineOfPoemTextView.attributedText = [self getCurrentAttributeString];
    _translatedTextView.text = poemLines[currentLine][@"translated"][_currentTranslatedLanguage];
    isShowingTranslatedLabel = NO;
    _translatedTextView.alpha = 0;
}
- (void)initPoemView
{
    [self initSystemConfiguration];
    //[self initBackgroundImageViewAnimation];
    UISwipeGestureRecognizer* swipeUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeUpGesture:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    UISwipeGestureRecognizer* swipeDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeDownGesture:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self addGestureRecognizer:swipeUp];
    [self addGestureRecognizer:swipeDown];
    [self addSubview:self.backgroundImageView];
    //[self addSubview:self.backgroundScrollView];
    [self addSubview:self.currentLineOfPoemTextView];
    [self addSubview:self.alternativeLinePoemTextView];
    [self addSubview:self.translatedTextView];
    [self addSubview:self.explanationView];
    
    UITapGestureRecognizer* tapLine1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
    UITapGestureRecognizer* tapLine2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
    _currentLineOfPoemTextView.userInteractionEnabled = YES;
    _alternativeLinePoemTextView.userInteractionEnabled = YES;
    [_currentLineOfPoemTextView addGestureRecognizer:tapLine1];
    [_alternativeLinePoemTextView addGestureRecognizer:tapLine2];
    
    UISwipeGestureRecognizer* swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeRightGesture:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swipeRight];
    
  
    //[self initPoemData];
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGRect sFrame = [UIScreen mainScreen].bounds;
    if (CGRectContainsPoint(CGRectMake(0, sFrame.size.height * 3 / 5, sFrame.size.width, sFrame.size.height * 2 / 5),[touch locationInView:self])) {
        CGRect f = _currentLineOfPoemTextView.frame;
        if(isShowingTranslatedLabel){
            
            [UIView animateWithDuration:0.2 animations:^{
                //_translatedLabel.frame = CGRectMake(f.origin.x, f.origin.y - f.size.height, f.size.width, f.size.height);
                _translatedTextView.alpha = 0;
            } completion:^(BOOL finished) {
                isShowingTranslatedLabel = NO;
            }];
            return;
        }
        _translatedTextView.frame = CGRectMake(f.origin.x, f.origin.y, f.size.width, f.size.height);
        _translatedTextView.text =  poemLines[currentLine][@"translated"][_currentTranslatedLanguage];
        
        [UIView animateWithDuration:0.2 animations:^{
            _translatedTextView.frame = CGRectMake(f.origin.x, f.origin.y + f.size.height, f.size.width, f.size.height);
            _translatedTextView.alpha = 1;
        } completion:^(BOOL finished) {
            isShowingTranslatedLabel = YES;
        }];
    }
}
@end
