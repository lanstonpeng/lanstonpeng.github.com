//
//  PoemCell.m
//  Poem
//
//  Created by Lanston Peng on 6/2/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PoemCell.h"
#import "UIImage+PoemResouces.h"
#import "PoemDetailView.h"
#import "PoemIntroductionView.h"
//#import "CustomUIScrollView.h"

#define BgViewOpacityStartPoint 0.95
#define BgViewOpacityEndPoint  0.3
#define RightMargin 10
//#define TitleFont @"QuicksandLight"
//#define TitleFont @"STHeitiSC-Light"

//#define TitleFont @"AppleSDGothicNeo-Thin"
//#define AuthorFont @"AmericanTyperwriter-Light"

#define TitleFont @"AppleSDGothicNeo-Thin"
#define AuthorFont @"AppleSDGothicNeo-Thin"


@interface PoemCell()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    CGRect sFrame;
    UIImageView* bgView;
    //the poem scrollView
    UIScrollView* bgScrollView;
    //the author / poem background scrollView
    UIScrollView* poemBackgroundScrollView;
    
    UIView* scrollIndicatorView;
    UIView* scrollIndicatorViewRight;
    BOOL isChanging;
    PoemDetailView* poemDetailView;
    PoemIntroductionView* poemIntroductionView;
    
    CALayer* bgMaskLayer;
    CGPoint currentContentOffset;
    UILabel* author;
    UILabel* title;
    
    CGPoint startPos;
    int     scrollDirection;
    
    CGRect poemDetailFrame;
    CGRect poemIntroductionViewFrame;
    
    CGRect bgScrollViewFrame;
    CGRect poemBackgroundScrollViewFrame;
    
    BOOL pulling;
    BOOL isScrollDecelarating;
    float inOutScrollDecelerateRatio;
    
    BOOL isTouchScreen;
    NSTimer* fadeInTimer;
    
    CABasicAnimation* opacity;
    
}
@end
@implementation PoemCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        [self initUI];
    }
    return self;
}
- (void)initData:(NSDictionary*)poem
{
    
    
    int xPositiveSymbol = arc4random() % 10 > 5 ? 1 : -1;
    int yPositiveSymbol = arc4random() % 10 > 5 ? 1 : -1;
    
    UIImage* backgroundImg = (UIImage*)[[UIImage alloc]initWithName:poem[@"bgimg"]];
    self.poemData = poem;
    bgView.image = backgroundImg;
    bgView.contentMode = UIViewContentModeScaleAspectFill;
    
    bgView.layer.anchorPoint = CGPointMake(0.5,0.5);
    CAAnimationGroup* group = [CAAnimationGroup animation];
    group.duration = 30;
    CABasicAnimation* horizontalMove = [CABasicAnimation animationWithKeyPath:@"position.x"];
    horizontalMove.fromValue = @(bgView.layer.position.x);
    horizontalMove.toValue = @((int)(bgView.layer.position.x) + (int)((arc4random() % 15 + 5 ) * xPositiveSymbol));
    
    CABasicAnimation* verticalMove = [CABasicAnimation animationWithKeyPath:@"position.y"];
    verticalMove.fromValue = @(bgView.layer.position.y);
    verticalMove.toValue = @((int)(bgView.layer.position.y) + (int)((arc4random() % 15 + 5 ) * yPositiveSymbol));
    
    CABasicAnimation* scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    [scale setFromValue:[NSNumber numberWithFloat:1.0f]];
    [scale setToValue:[NSNumber numberWithFloat:1.2f]];
    
    opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacity.fromValue = @(BgViewOpacityStartPoint);
    opacity.toValue = @(BgViewOpacityEndPoint);
    opacity.duration = 1;
    opacity.fillMode = kCAFillModeForwards;
    opacity.delegate = self;
    //opacity.removedOnCompletion = NO;
    
    group.animations = @[horizontalMove,verticalMove,scale];
    
    
    [group setRemovedOnCompletion:NO];
    [group setFillMode:kCAFillModeForwards];
    [bgView.layer addAnimation:group forKey:@"groupAnimation"];
    [bgMaskLayer addAnimation:opacity forKey:@"maskLayerAnimation"];
    bgMaskLayer.opacity = BgViewOpacityEndPoint;
    
    author.text = poem[@"author"];
    title.text = poem[@"title"];
    
    if(title.text.length>30)
    {
        title.numberOfLines = 3;
        title.frame = CGRectMake(0, bgScrollViewFrame.size.height - 150 , bgScrollViewFrame.size.width - MaxScrollPull - RightMargin , 150);
    }
    NSMutableAttributedString* attrStr = [[NSMutableAttributedString alloc]initWithString:title.text];
    NSRange range = NSMakeRange(0, title.text.length);
    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:TitleFont size:40] range:range];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:range];
    NSMutableParagraphStyle *paragrapStyle = [[NSMutableParagraphStyle alloc] init];
    paragrapStyle.alignment = NSTextAlignmentRight;
    paragrapStyle.firstLineHeadIndent = 20;
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragrapStyle range:range];
    title.attributedText = attrStr;
    
}
- (void)startAnimation
{
    /*
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    [scale setFromValue:[NSNumber numberWithFloat:1.0f]];
    [scale setToValue:[NSNumber numberWithFloat:1.3f]];
    [scale setDuration:3.0f];
    [scale setRemovedOnCompletion:NO];
    [scale setFillMode:kCAFillModeForwards];
    [bgView.layer addAnimation:scale forKey:@"test"];
     */
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    //[self startAnimation];
    //bgMaskLayer.opacity = 0.3;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}
- (void)initUI
{
    sFrame = [UIScreen mainScreen].bounds;
    bgView = [[UIImageView alloc]initWithFrame:CGRectMake(-20, 0, sFrame.size.width + 40, sFrame.size.height + 40)];
    bgMaskLayer = [CALayer layer];
    bgMaskLayer.opacity = BgViewOpacityStartPoint;
    //bgMaskLayer.frame = CGRectMake(-20, 0, sFrame.size.width + 80 , sFrame.size.height);
    //bgMaskLayer.frame = bgView.frame;
    bgMaskLayer.frame = CGRectMake(0, 0, bgView.frame.size.width, bgView.frame.size.height);
    bgMaskLayer.backgroundColor = [UIColor blackColor].CGColor;
    [bgView.layer addSublayer:bgMaskLayer];
    
    //gradient layer
    CALayer* shadowLayer = [CALayer layer];
    //bgView.clipsToBounds = NO;
    shadowLayer.frame = CGRectMake(-20,bgView.frame.size.height - sFrame.size.height/8, sFrame.size.width+40 ,  sFrame.size.height /4);
    shadowLayer.shadowPath = [[UIBezierPath bezierPathWithRect:CGRectMake(0,-40,sFrame.size.width +80, shadowLayer.frame.size.height)]  CGPath];
    [shadowLayer setShadowColor:UIColorFromRGB(0x00000).CGColor];
    //[shadowLayer setShadowColor:UIColorFromRGB(0x9A74E4).CGColor];
    [shadowLayer setShadowOpacity:0.9];
    [shadowLayer setShadowRadius:30.0];
    [shadowLayer setShadowOffset:CGSizeMake(0, -2.0)];
    [bgView.layer addSublayer:shadowLayer];
    
    [self addSubview:bgView];

    
    CGFloat pageWidth = sFrame.size.width + MaxScrollPull;
    bgScrollViewFrame = CGRectMake(0, 0, pageWidth, bgView.frame.size.height - 120);
    poemBackgroundScrollViewFrame = CGRectMake(0, bgScrollViewFrame.size.height, pageWidth, sFrame.size.height - bgScrollViewFrame.size.height);
    
    bgScrollView = [[UIScrollView alloc]initWithFrame:bgScrollViewFrame];
    bgScrollView.tag = 100;
    //bgScrollView.backgroundColor = [UIColor redColor];
    poemBackgroundScrollView = [[UIScrollView alloc]initWithFrame:poemBackgroundScrollViewFrame];
    poemBackgroundScrollView.tag = 200;
    
    bgScrollView.contentSize = CGSizeMake(pageWidth*2, bgScrollView.frame.size.height);
    poemBackgroundScrollView.contentSize = CGSizeMake(pageWidth*2,poemBackgroundScrollView.frame.size.height );
    
    bgScrollView.delegate = self;
    bgScrollView.showsVerticalScrollIndicator = NO;
    bgScrollView.showsHorizontalScrollIndicator = NO;
    bgScrollView.pagingEnabled = YES;
    bgScrollView.clipsToBounds = NO;
    
    poemBackgroundScrollView.delegate = self;
    poemBackgroundScrollView.showsVerticalScrollIndicator = NO;
    poemBackgroundScrollView.showsHorizontalScrollIndicator = NO;
    poemBackgroundScrollView.pagingEnabled = YES;
    poemBackgroundScrollView.clipsToBounds = NO;
    
    //bgScrollView.directionalLockEnabled = YES;
    //bgScrollView.alwaysBounceVertical = YES;
    //bgScrollView.bounces = NO;
    [bgScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    CGRect titleFrame = CGRectMake(0, bgScrollViewFrame.size.height - 100 , bgScrollViewFrame.size.width - MaxScrollPull - RightMargin, 100);
    CGRect authorFrame = CGRectMake(0, 10 , poemBackgroundScrollViewFrame.size.width - MaxScrollPull - RightMargin , poemBackgroundScrollViewFrame.size.height - 10);
    
    author = [[UILabel alloc]initWithFrame:authorFrame];
    author.adjustsFontSizeToFitWidth = YES;
    author.numberOfLines = 2;
    author.textAlignment = NSTextAlignmentRight;
    //author.font = [UIFont fontWithName: @"Helvetica-Bold" size:20];
    author.font = [UIFont fontWithName:AuthorFont size:20];
    author.textColor = [UIColor whiteColor];
    //author.backgroundColor = [UIColor orangeColor];
    //author.lineBreakMode = NSLineBreakByCharWrapping;
    
    title = [[UILabel alloc]initWithFrame:titleFrame];
    //title.backgroundColor = [UIColor blueColor];
    //title.adjustsFontSizeToFitWidth = YES;
    title.font = [UIFont fontWithName:TitleFont size:40];
    title.numberOfLines = 3;
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentRight;
    
    CALayer* titleLayer = title.layer;
    titleLayer.masksToBounds = NO;
    titleLayer.shadowColor = [UIColor blackColor].CGColor;
    [titleLayer setShadowOpacity:1];
    [titleLayer setShadowRadius:0.5];
    [titleLayer setShadowOffset:CGSizeMake(1, 1)];
    

    //title.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //UIView* titleBgView = [[UIView alloc]initWithFrame: CGRectMake(-2* MaxScrollPull,  title.frame.origin.y, 2* sFrame.size.width, title.frame.size.height)];
    //titleBgView.backgroundColor =[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //[self addSubview:titleBgView];
    
    
    
    UIView* separator = [[UIView alloc]initWithFrame:CGRectMake(0, titleFrame.origin.y + titleFrame.size.height + 10, sFrame.size.width , 0.5 )];
    scrollIndicatorView = [[UIView alloc]initWithFrame:CGRectMake(separator.frame.origin.x, separator.frame.origin.y,0,separator.frame.size.height)];
    scrollIndicatorViewRight = [[UIView alloc]initWithFrame:CGRectMake(separator.frame.origin.x + separator.frame.size.width, separator.frame.origin.y,0,separator.frame.size.height)];
    scrollIndicatorView.backgroundColor = UIColorFromRGB(0xffffff);
    scrollIndicatorViewRight.backgroundColor = UIColorFromRGB(0x16C2A3);
    separator.backgroundColor =UIColorFromRGB(0x01BEFC);
    [self addSubview:separator];
    [self addSubview:scrollIndicatorView];
    [self addSubview:scrollIndicatorViewRight];
    
    [bgScrollView addSubview:title];
    [poemBackgroundScrollView addSubview:author];
    [self addSubview:bgScrollView];
    [self addSubview:poemBackgroundScrollView];
    poemDetailFrame = CGRectMake(self.frame.size.width, 0, self.frame.size.width * 2, self.frame.size.height);
    poemIntroductionViewFrame = CGRectMake(self.frame.size.width, 0, self.frame.size.width * 2, self.frame.size.height);
}
- (void)setUpPoem:(NSDictionary*)poem
{
    [self initData:poem];
    
    //poemDetailView = [[PoemDetailView alloc]initWithFrame:poemDetailFrame];
    //poemIntroductionView = [[PoemIntroductionView alloc]initWithFrame:poemIntroductionViewFrame];
    //[bgScrollView addSubview:poemDetailView];
    //[poemBackgroundScrollView addSubview:poemIntroductionView];
    
}

-(void)bgScrollViewDidScroll:(UIScrollView *)scrollView
{
    //[bgView.layer removeAllAnimations];
    
    //CGFloat bgViewOffset =  MAX(0, scrollView.contentOffset.x / 10);
    //CGRect f = [[bgView.layer presentationLayer] frame];
   // bgView.frame = CGRectMake(f.origin.x - bgViewOffset, f.origin.y, bgView.frame.size.width, bgView.frame.size.height);
    
    //NSLog(@"bgView.frame %f",bgViewOffset);
    float offsetPercent =  scrollView.contentOffset.x / (poemDetailFrame.size.width/2);
    [bgMaskLayer removeAnimationForKey:@"maskLayerAnimation"];
    bgMaskLayer.opacity = BgViewOpacityEndPoint + 2 * offsetPercent * (1 - BgViewOpacityEndPoint);
    //NSLog(@"did scroll %f",bgMaskLayer.opacity);
    //poemDetailView.bgMaskLayer.opacity = 0.8 + offsetPercent * 0.2;
    //author.frame = CGRectMake(-scrollView.contentOffset.x /20, author.frame.origin.y, author.frame.size.width, author.frame.size.height);
    title.frame = CGRectMake(-scrollView.contentOffset.x /20, title.frame.origin.y, title.frame.size.width, title.frame.size.height);
    
    author.alpha = 1.0 - offsetPercent;
    title.alpha = 1.0 - offsetPercent;
    
    
    CGFloat offset = scrollView.contentOffset.x ;
    if ( offset > MaxScrollPull && !pulling) {
        //[self.delegate willBeginPull:scrollView.contentOffset];
        pulling = YES;
        self.presentationType = PoemDetailType;
        [self.delegate poemCellDidBeginPulling:self];
    }
    if(pulling)
    {
        CGFloat pulloffset;
        if(!isScrollDecelarating)
        {
            pulloffset =  MAX(0, offset - MaxScrollPull);
        }
        else
        {
            pulloffset = offset * inOutScrollDecelerateRatio;
        }
        [self.delegate poemCell:self didChangePullOffset:pulloffset];
        bgScrollView.transform = CGAffineTransformMakeTranslation(pulloffset, 0);
    }
}
-(void)poemBackgroundViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat offset = scrollView.contentOffset.x ;
    if ( offset > MaxScrollPull && !pulling) {
        //[self.delegate willBeginPull:scrollView.contentOffset];
        pulling = YES;
        self.presentationType = PoemIntroduction;
        [self.delegate poemCellDidBeginPulling:self];
    }
    if(pulling)
    {
        CGFloat pulloffset;
        if(!isScrollDecelarating)
        {
            pulloffset =  MAX(0, offset - MaxScrollPull);
        }
        else
        {
            pulloffset = offset * inOutScrollDecelerateRatio;
        }
        [self.delegate poemCell:self didChangePullOffset:pulloffset];
        poemBackgroundScrollView.transform = CGAffineTransformMakeTranslation(pulloffset, 0);
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    switch (scrollView.tag) {
        case 100:
            [self bgScrollViewDidScroll:scrollView];
            break;
        case 200:
            [self poemBackgroundViewDidScroll:scrollView];
            break;
        default:
            break;
    }
}

- (void)scrollingEnd
{
    [self.delegate poemCellDidEndPulling:self];
    pulling = NO;
    isScrollDecelarating = NO;
    poemBackgroundScrollView.contentOffset = CGPointZero;
    poemBackgroundScrollView.transform =CGAffineTransformIdentity;
    bgScrollView.contentOffset = CGPointZero;
    bgScrollView.transform =CGAffineTransformIdentity;
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGFloat offset =  scrollView.contentOffset.x;
    if (offset > 0 && (*targetContentOffset).x == 0)
    {
        isScrollDecelarating = YES;
        CGFloat pullOffset = MAX(0,offset - MaxScrollPull);
        inOutScrollDecelerateRatio = pullOffset / offset;
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //scrollDirection = 3;
    if(!decelerate)
    {
        [self scrollingEnd];
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //[scrollView setContentOffset:scrollView.contentOffset animated:YES];
    //[self.delegate poemCellDidEndPulling:self];
    [self scrollingEnd];
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //NSLog(@"end animation %f %f",scrollView.contentOffset.x,scrollView.contentOffset.y);
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
}

- (void)fadeInAuthorImage
{
    float newOpacity = MAX(0,bgMaskLayer.opacity + 0.02);
    [UIView animateWithDuration:0.03f delay:0.00 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        bgMaskLayer.opacity = newOpacity;
    } completion:^(BOOL finished) {
    }];
}
- (void)fadeOutAuthorImage
{
    [UIView animateWithDuration:0.3f delay:0.05 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        bgMaskLayer.opacity = BgViewOpacityStartPoint;
    } completion:^(BOOL finished) {
    }];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    isTouchScreen = YES;
    fadeInTimer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(fadeInAuthorImage) userInfo:nil repeats:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    isTouchScreen = NO;
    [fadeInTimer invalidate];
    fadeInTimer = nil;
    [self fadeOutAuthorImage];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"contentOffset"])
    {
        float width = sFrame.size.width * bgScrollView.contentOffset.x / MaxScrollPull;
        if (width >= 0) {
            scrollIndicatorView.frame = CGRectMake(scrollIndicatorView.frame.origin.x , scrollIndicatorView.frame.origin.y,
                                                   width, scrollIndicatorView.frame.size.height);
        }
        else
        {
            scrollIndicatorViewRight.frame = CGRectMake( sFrame.size.width +  width , scrollIndicatorViewRight.frame.origin.y,
                                                   -width, scrollIndicatorViewRight.frame.size.height);
        }
    }
}
@end
