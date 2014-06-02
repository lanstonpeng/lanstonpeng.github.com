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

@interface PoemCell()<UIScrollViewDelegate>
{
    UIImageView* bgView;
    UIScrollView* bgScrollView;
    UIView* scrollIndicatorView;
    BOOL isChanging;
    PoemDetailView* poemDetailView;
    CALayer* bgMaskLayer;
    CGPoint currentContentOffset;
    UILabel* author;
    UILabel* title;
    
    CGPoint startPos;
    int     scrollDirection;
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

- (void)initUI
{
    CGRect sFrame = [UIScreen mainScreen].bounds;
    bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, sFrame.size.width, sFrame.size.height )];
    bgMaskLayer = [CALayer layer];
    bgMaskLayer.opacity = 0.5;
    bgMaskLayer.frame = CGRectMake(-20, 0, sFrame.size.width + 80 , sFrame.size.height);
    bgMaskLayer.backgroundColor = [UIColor blackColor].CGColor;
    [bgView.layer addSublayer:bgMaskLayer];
    UIImage* backgroundImg = (UIImage*)[[UIImage alloc]initWithName:@"Shakespeare"];

    bgView.image = backgroundImg;
    [self addSubview:bgView];
    
    bgScrollView = [[UIScrollView alloc]initWithFrame:bgView.frame];
    bgScrollView.contentSize = CGSizeMake(bgScrollView.frame.size.width*2, bgScrollView.frame.size.height );
    bgScrollView.delegate = self;
    //bgScrollView.showsVerticalScrollIndicator = YES;
    //bgScrollView.showsHorizontalScrollIndicator = YES;
    bgScrollView.pagingEnabled = YES;
    bgScrollView.directionalLockEnabled = YES;
    bgScrollView.alwaysBounceVertical = YES;
    //bgScrollView.bounces = NO;
    [bgScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    author = [[UILabel alloc]initWithFrame:CGRectMake(10, sFrame.size.height - 200 , sFrame.size.width - 20, 100)];
    author.text = @"William Shakespeare";
    author.numberOfLines = 0;
    author.textAlignment = NSTextAlignmentRight;
    author.font = [UIFont fontWithName: @"Helvetica-Bold" size:40];
    author.textColor = [UIColor whiteColor];
    
    UIView* separator = [[UIView alloc]initWithFrame:CGRectMake(20, author.frame.origin.y + author.frame.size.height + 10, sFrame.size.width - 20, 0.5 )];
    scrollIndicatorView = [[UIView alloc]initWithFrame:CGRectMake(separator.frame.origin.x, separator.frame.origin.y,0,separator.frame.size.height)];
    scrollIndicatorView.backgroundColor = [UIColor blackColor];
    separator.backgroundColor = [UIColor whiteColor];
    [self addSubview:separator];
    [self addSubview:scrollIndicatorView];
    
    title = [[UILabel alloc]initWithFrame:CGRectMake(10, sFrame.size.height - 100 , sFrame.size.width- 20, 100)];
    title.text = @"Sonnet - Shall I compare thee to a summer's day";
    title.font = [UIFont fontWithName:@"STHeitiSC-Light" size:16];
    title.numberOfLines = 0;
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentRight;
    
    
    
    poemDetailView = [[PoemDetailView alloc]initWithFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width * 2, self.frame.size.height)];
    
    [bgScrollView addSubview:poemDetailView];
    [bgScrollView addSubview:author];
    [bgScrollView addSubview:title];
    [self addSubview:bgScrollView];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"%f %f",scrollView.contentOffset.x,scrollView.contentOffset.y);
    
    static NSInteger previousPage = 0;
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    if (page != previousPage) {
        scrollView.alwaysBounceVertical =!scrollView.alwaysBounceVertical;
        previousPage = page;
        if(page == 0)
        {
            [self.delegate didHidePoemDetail];
        }
        else
        {
            [self.delegate didShowPoemDetail];
        }
    }
    
    if (scrollDirection==0){//we need to determine direction
        //use the difference between positions to determine the direction.
        if (abs(startPos.x-scrollView.contentOffset.x)<abs(startPos.y-scrollView.contentOffset.y)){
            //NSLog(@"Vertical Scrolling");
            scrollDirection=1;
        } else {
            //NSLog(@"Horitonzal Scrolling");
            scrollDirection=2;
        }
    }
    bgView.frame = CGRectMake(-scrollView.contentOffset.x / 10, bgView.frame.origin.y, bgView.frame.size.width, bgView.frame.size.height);
    float offsetPercent =  scrollView.contentOffset.x / (poemDetailView.frame.size.width/2);
    bgMaskLayer.opacity = 0.5 + offsetPercent* 0.5;
    poemDetailView.bgMaskLayer.opacity = 0.8 + offsetPercent * 0.2;
    author.frame = CGRectMake(-scrollView.contentOffset.x /20, author.frame.origin.y, author.frame.size.width, author.frame.size.height);
    title.frame = CGRectMake(-scrollView.contentOffset.x /20, title.frame.origin.y, title.frame.size.width, title.frame.size.height);
    
    author.alpha = 1.0 - offsetPercent;
    title.alpha = 1.0 - offsetPercent;
    
    
    if (scrollDirection==1) {
        [scrollView setContentOffset:CGPointMake(startPos.x,scrollView.contentOffset.y) animated:NO];
    } else if (scrollDirection==2){
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x,startPos.y) animated:NO];
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    scrollDirection = 3;
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    
    return;
    float delta = scrollView.contentOffset.x;
    if(delta > bgView.frame.size.width * 0.5 && delta < bgView.frame.size.width)
    {
        //open the poem
        currentContentOffset =  CGPointMake(bgView.frame.size.width * 0.75, 0);
        //*targetContentOffset = currentContentOffset;
        [scrollView setContentOffset:currentContentOffset animated:YES];
    }
    else if( delta <= bgView.frame.size.width*0.5 && delta > 0)
    {
        //collapse it
        currentContentOffset = CGPointMake(0, 0);
        //*targetContentOffset = currentContentOffset;
        [scrollView setContentOffset:currentContentOffset animated:YES];
    }
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSLog(@"end animation %f %f",scrollView.contentOffset.x,scrollView.contentOffset.y);
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    startPos = scrollView.contentOffset;
    scrollDirection=0;
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //[scrollView setContentOffset:scrollView.contentOffset animated:YES];
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
