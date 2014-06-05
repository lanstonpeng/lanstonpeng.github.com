//
//  PoemCell.m
//  Poem
//
//  Created by Lanston Peng on 6/2/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "PoemCell.h"
#import "UIImage+PoemResouces.h"
#import "PoemDetailView.h"
#import "PoemIntroductionView.h"

@interface PoemCell()<UIScrollViewDelegate>
{
    UIImageView* bgView;
    //the poem scrollView
    UIScrollView* bgScrollView;
    //the author / poem background scrollView
    UIScrollView* poemBackgroundScrollView;
    
    UIView* scrollIndicatorView;
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
    
    
}
@end
@implementation PoemCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}
- (void)initData:(NSDictionary*)poem
{
    
    UIImage* backgroundImg = (UIImage*)[[UIImage alloc]initWithName:poem[@"bgimg"]];
    self.poemData = poem;
    bgView.image = backgroundImg;
    author.text = poem[@"author"];
    title.text = poem[@"title"];
}
- (void)initUI
{
    CGRect sFrame = [UIScreen mainScreen].bounds;
    bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, sFrame.size.width, sFrame.size.height )];
    bgMaskLayer = [CALayer layer];
    bgMaskLayer.opacity = 0.5;
    bgMaskLayer.frame = CGRectMake(-20, 0, sFrame.size.width + 80 , sFrame.size.height);
    bgMaskLayer.backgroundColor = [UIColor blackColor].CGColor;
    [bgView.layer addSublayer:bgMaskLayer];
    [self addSubview:bgView];
    
    CGFloat pageWidth = sFrame.size.width + MaxScrollPull;
    bgScrollViewFrame = CGRectMake(0, 0, pageWidth, bgView.frame.size.height - 100);
    poemBackgroundScrollViewFrame = CGRectMake(0, bgScrollViewFrame.size.height, pageWidth, 100);
    
    bgScrollView = [[UIScrollView alloc]initWithFrame:bgScrollViewFrame];
    bgScrollView.tag = 100;
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
    
    CGRect titileFrame = CGRectMake(0, sFrame.size.height - 200 , sFrame.size.width, 100);
    CGRect authorFrame = CGRectMake(0, 0 , pageWidth - MaxScrollPull, 100);
    
    author = [[UILabel alloc]initWithFrame:authorFrame];
    author.adjustsFontSizeToFitWidth = YES;
    author.numberOfLines = 2;
    author.textAlignment = NSTextAlignmentRight;
    author.font = [UIFont fontWithName: @"Helvetica-Bold" size:20];
    author.textColor = [UIColor whiteColor];
    //author.backgroundColor = [UIColor orangeColor];
    //author.lineBreakMode = NSLineBreakByCharWrapping;
    
    title = [[UILabel alloc]initWithFrame:titileFrame];
    title.adjustsFontSizeToFitWidth = YES;
    title.font = [UIFont fontWithName:@"STHeitiSC-Light" size:40];
    title.numberOfLines = 2;
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentRight;
    //title.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    
    
    
    UIView* separator = [[UIView alloc]initWithFrame:CGRectMake(20, titileFrame.origin.y + titileFrame.size.height + 10, sFrame.size.width - 20, 0.5 )];
    scrollIndicatorView = [[UIView alloc]initWithFrame:CGRectMake(separator.frame.origin.x, separator.frame.origin.y,0,separator.frame.size.height)];
    scrollIndicatorView.backgroundColor = [UIColor blackColor];
    separator.backgroundColor = [UIColor whiteColor];
    [self addSubview:separator];
    [self addSubview:scrollIndicatorView];
    
    [bgScrollView addSubview:title];
    [poemBackgroundScrollView addSubview:author];
    [self addSubview:bgScrollView];
    [self addSubview:poemBackgroundScrollView];
    poemDetailFrame = CGRectMake(self.frame.size.width, 0, self.frame.size.width * 2, self.frame.size.height);
    poemIntroductionViewFrame = CGRectMake(self.frame.size.width, 100-self.frame.size.height, self.frame.size.width * 2, self.frame.size.height);
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
    CGFloat bgViewOffset =  MAX(0, scrollView.contentOffset.x / 10);
    bgView.frame = CGRectMake(-bgViewOffset, bgView.frame.origin.y, bgView.frame.size.width, bgView.frame.size.height);
    float offsetPercent =  scrollView.contentOffset.x / (poemDetailFrame.size.width/2);
    bgMaskLayer.opacity = 0.5 + offsetPercent* 0.5;
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
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"contentOffset"])
    {
        float width = 300 * bgScrollView.contentOffset.x / 80;
        if (width >= 0) {
            scrollIndicatorView.frame = CGRectMake(scrollIndicatorView.frame.origin.x , scrollIndicatorView.frame.origin.y,
                                                   width, scrollIndicatorView.frame.size.height);
        }
    }
}
@end
