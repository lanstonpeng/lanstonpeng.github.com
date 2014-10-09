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
#define TitleFont @"AppleSDGothicNeo-Thin"
#define AuthorFont @"AppleSDGothicNeo-Thin"


@interface PoemCell()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    CGRect sFrame;
    //the poem scrollView
    UIScrollView* bgScrollView;
    //the author / poem background scrollView
    UIScrollView* poemIntroductionScrollView;
    
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
    CGRect poemIntroductionFrame;
    
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
    
    //UIImage* backgroundImg = (UIImage*)[[UIImage alloc]initWithName:poem[@"bgimg"]];
    UIImage* backgroundImg = nil;
    self.poemData = poem;
    self.bgView.image = backgroundImg;
    self.bgView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.bgView.layer.anchorPoint = CGPointMake(0.5,0.5);
    
    author.text = poem[@"author"];
    title.text = poem[@"title"];
    
    if(title.text.length>30)
    {
        title.numberOfLines = 3;
        title.frame = CGRectMake(title.frame.origin.x, bgScrollViewFrame.size.height - 150 , bgScrollViewFrame.size.width - MaxScrollPull - RightMargin , 150);
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
    
    [self startAnimation];
}
- (void)startAnimation
{
    
    int xPositiveSymbol = arc4random() % 10 > 5 ? 1 : -1;
    int yPositiveSymbol = arc4random() % 10 > 5 ? 1 : -1;
    CAAnimationGroup* group = [CAAnimationGroup animation];
    group.duration = 30;
    CABasicAnimation* horizontalMove = [CABasicAnimation animationWithKeyPath:@"position.x"];
    horizontalMove.fromValue = @(self.bgView.layer.position.x);
    horizontalMove.toValue = @((int)(self.bgView.layer.position.x) + (int)((arc4random() % 15 + 5 ) * xPositiveSymbol));
    
    CABasicAnimation* verticalMove = [CABasicAnimation animationWithKeyPath:@"position.y"];
    verticalMove.fromValue = @(self.bgView.layer.position.y);
    verticalMove.toValue = @((int)(self.bgView.layer.position.y) + (int)((arc4random() % 15 + 5 ) * yPositiveSymbol));
    
    CABasicAnimation* scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    [scale setFromValue:[NSNumber numberWithFloat:1.0f]];
    [scale setToValue:[NSNumber numberWithFloat:1.2f]];
    
    opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacity.fromValue = @(BgViewOpacityStartPoint);
    opacity.toValue = @(BgViewOpacityEndPoint);
    opacity.duration = 2;
    opacity.fillMode = kCAFillModeForwards;
    opacity.delegate = self;
    //opacity.removedOnCompletion = NO;
    
    group.animations = @[horizontalMove,verticalMove,scale];
    
    
    [group setRemovedOnCompletion:NO];
    [group setFillMode:kCAFillModeForwards];
    [self.bgView.layer addAnimation:group forKey:@"groupAnimation"];
    [bgMaskLayer addAnimation:opacity forKey:@"maskLayerAnimation"];
     bgMaskLayer.opacity = BgViewOpacityEndPoint;
}
- (void)stopAnimation
{
    //reset the animatable property
    [self.bgView.layer removeAllAnimations];
    self.bgView.frame = CGRectMake(-20, 0, sFrame.size.width + 40, sFrame.size.height + 40);
    bgMaskLayer.opacity = BgViewOpacityStartPoint;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}
- (void)initUI
{
    sFrame = [UIScreen mainScreen].bounds;
    self.bgView = [[UIImageView alloc]initWithFrame:CGRectMake(-20, 0, sFrame.size.width + 40, sFrame.size.height + 40)];
    bgMaskLayer = [CALayer layer];
    bgMaskLayer.opacity = BgViewOpacityStartPoint;
    bgMaskLayer.frame = CGRectMake(0, 0, self.bgView.frame.size.width, self.bgView.frame.size.height);
    bgMaskLayer.backgroundColor = [UIColor blackColor].CGColor;
    [self.bgView.layer addSublayer:bgMaskLayer];
    
    //TODO replace it with images
    CALayer* shadowLayer = [CALayer layer];
    shadowLayer.frame = CGRectMake(-20,self.bgView.frame.size.height - sFrame.size.height/8, sFrame.size.width+40 ,  sFrame.size.height /4);
    shadowLayer.shadowPath = [[UIBezierPath bezierPathWithRect:CGRectMake(0,-40,sFrame.size.width +80, shadowLayer.frame.size.height)]  CGPath];
    [shadowLayer setShadowColor:UIColorFromRGB(0x00000).CGColor];
    //[shadowLayer setShadowColor:UIColorFromRGB(0x9A74E4).CGColor];
    [shadowLayer setShadowOpacity:0.9];
    [shadowLayer setShadowRadius:30.0];
    [shadowLayer setShadowOffset:CGSizeMake(0, -2.0)];
    [self.bgView.layer addSublayer:shadowLayer];
    
    [self addSubview:self.bgView];

    
    CGFloat pageWidth = sFrame.size.width + MaxScrollPull;
    bgScrollViewFrame = CGRectMake(0, 0, pageWidth, self.bgView.frame.size.height - 120);
    poemIntroductionFrame = CGRectMake(0, bgScrollViewFrame.size.height, pageWidth, sFrame.size.height - bgScrollViewFrame.size.height);
    
    bgScrollView = [[UIScrollView alloc]initWithFrame:bgScrollViewFrame];
    bgScrollView.tag = 100;
    poemIntroductionScrollView = [[UIScrollView alloc]initWithFrame:poemIntroductionFrame];
    poemIntroductionScrollView.tag = 200;
    
    bgScrollView.contentSize = CGSizeMake(pageWidth * 3, bgScrollView.frame.size.height);
    bgScrollView.contentOffset = CGPointMake(pageWidth, 0);
    poemIntroductionScrollView.contentSize = CGSizeMake(pageWidth * 2,poemIntroductionScrollView.frame.size.height );
    
    bgScrollView.delegate = self;
    bgScrollView.showsVerticalScrollIndicator = NO;
    bgScrollView.showsHorizontalScrollIndicator = NO;
    bgScrollView.pagingEnabled = YES;
    bgScrollView.clipsToBounds = NO;
    
    poemIntroductionScrollView.delegate = self;
    poemIntroductionScrollView.showsVerticalScrollIndicator = NO;
    poemIntroductionScrollView.showsHorizontalScrollIndicator = NO;
    poemIntroductionScrollView.pagingEnabled = YES;
    poemIntroductionScrollView.clipsToBounds = NO;
    
    //[bgScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    CGRect titleFrame = CGRectMake(pageWidth, bgScrollViewFrame.size.height - 100 , pageWidth - MaxScrollPull - RightMargin, 100);
    CGRect authorFrame = CGRectMake(0, 10 , poemIntroductionFrame.size.width - MaxScrollPull - RightMargin , poemIntroductionFrame.size.height - 10);
    
    author = [[UILabel alloc]initWithFrame:authorFrame];
    author.adjustsFontSizeToFitWidth = YES;
    author.numberOfLines = 2;
    author.textAlignment = NSTextAlignmentRight;
    author.font = [UIFont fontWithName:AuthorFont size:20];
    author.textColor = [UIColor whiteColor];
    
    title = [[UILabel alloc]initWithFrame:titleFrame];
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
    [poemIntroductionScrollView addSubview:author];
    [self addSubview:bgScrollView];
    [self addSubview:poemIntroductionScrollView];
    
    poemDetailFrame = CGRectMake(self.frame.size.width, 0, self.frame.size.width * 2, self.frame.size.height);
    poemIntroductionViewFrame = CGRectMake(self.frame.size.width, 0, self.frame.size.width * 2, self.frame.size.height);
}
- (void)setUpPoem:(NSDictionary*)poem
{
    [self initData:poem];
}

-(void)bgScrollViewDidScroll:(UIScrollView *)scrollView
{
    float offsetPercent =  (scrollView.contentOffset.x - sFrame.size.width - MaxScrollPull ) / (poemDetailFrame.size.width/2);
    [bgMaskLayer removeAnimationForKey:@"maskLayerAnimation"];
    bgMaskLayer.opacity = BgViewOpacityEndPoint + 2 * offsetPercent * (1 - BgViewOpacityEndPoint);
    
    author.alpha = 1.0 - offsetPercent;
    title.alpha = 1.0 - offsetPercent;
    
    
    CGFloat offset = scrollView.contentOffset.x - sFrame.size.width - MaxScrollPull ;
    
    if ( offset > MaxScrollPull && !pulling) {
        pulling = YES;
        self.presentationType = PoemDetailType;
        [self.delegate poemCellDidBeginPulling:self];
    }
    else if(offset < -MaxScrollPull && !pulling)
    {
        pulling = YES;
        self.presentationType = PoemList;
        [self. delegate poemCellDidBeginPulling:self];
    }
    
    if(pulling)
    {
        CGFloat pulloffset;
        if(!isScrollDecelarating)
        {
            if (offset > 0) {
                pulloffset = offset - MaxScrollPull;
            }
            else if(offset < 0)
            {
                pulloffset = offset + MaxScrollPull;
            }
        }
        else
        {
            pulloffset = offset * inOutScrollDecelerateRatio;
        }
        NSLog(@"~~> %f",pulloffset);
        [self.delegate poemCell:self didChangePullOffset:pulloffset];
        //TODO
        bgScrollView.transform = CGAffineTransformMakeTranslation(pulloffset, 0);
    }
}
//introducation view
-(void)poemBackgroundViewDidScroll:(UIScrollView *)scrollView
{
    
    //CGFloat offset = scrollView.contentOffset.x ;
    CGFloat offset = scrollView.contentOffset.x;
    if ( offset > MaxScrollPull && !pulling) {
        pulling = YES;
        self.presentationType = PoemIntroduction;
        [self.delegate poemCellDidBeginPulling:self];
    }
    if(pulling)
    {
        /*
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
         
        */
        CGFloat pulloffset;
        if(!isScrollDecelarating)
        {
//            if (offset > 0) {
//                pulloffset = offset - MaxScrollPull;
//            }
            pulloffset =  MAX(0, offset - MaxScrollPull);
        }
        else
        {
            pulloffset = offset * inOutScrollDecelerateRatio;
        }
        NSLog(@"==> %f",pulloffset);
        [self.delegate poemCell:self didChangePullOffset:pulloffset];
        poemIntroductionScrollView.transform = CGAffineTransformMakeTranslation(pulloffset, 0);
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
    NSLog(@"scrolling End");
    [self.delegate poemCellDidEndPulling:self];
    pulling = NO;
    isScrollDecelarating = NO;
    poemIntroductionScrollView.contentOffset = CGPointZero;
    poemIntroductionScrollView.transform = CGAffineTransformIdentity;
    bgScrollView.contentOffset = CGPointMake(sFrame.size.width + MaxScrollPull, 0);
    bgScrollView.transform = CGAffineTransformIdentity;
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGFloat offset =  scrollView.contentOffset.x;
    
    if (scrollView.tag == 100) {
        if ((*targetContentOffset).x == sFrame.size.width + MaxScrollPull) {
            isScrollDecelarating = YES;
            CGFloat pullOffset;
            if (offset - sFrame.size.width - MaxScrollPull > 0) {
                pullOffset = offset - sFrame.size.width - MaxScrollPull;
                inOutScrollDecelerateRatio = pullOffset / offset;
            }
            else
            {
                pullOffset = offset + sFrame.size.width + MaxScrollPull;
                inOutScrollDecelerateRatio = offset / pullOffset;
            }
        }
    }
    else if (scrollView.tag == 200)
    {
        if (offset > 0 && (*targetContentOffset).x == 0)
        {
            isScrollDecelarating = YES;
            CGFloat pullOffset = MAX(0,offset - MaxScrollPull);
            inOutScrollDecelerateRatio = pullOffset / offset;
        }
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
//TODO
/*
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
 */
@end
