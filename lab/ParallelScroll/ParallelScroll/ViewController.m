//
//  ViewController.m
//  ParallelScroll
//
//  Created by Lanston Peng on 6/6/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "ViewController.h"
#import "CustomCell.h"

@interface ViewController ()<UIScrollViewDelegate>
{
    CGRect sFrame;
    CGRect currentFrame;
    CGRect nextFrame;
    int currentIdx;
    int count;
}

@property (strong,nonatomic)UIScrollView* scrollView;

@property (strong,nonatomic)NSMutableArray* cellPoll;

@property (strong,nonatomic)CustomCell* prevCustomCellRef;
@property (strong,nonatomic)CustomCell* currentCustomCellRef;
@property (strong,nonatomic)CustomCell* nextCustomCellRef;
@end

@implementation ViewController


- (void)viewDidLoad
{
    
    count = 3;
    currentIdx = 1;
    [super viewDidLoad];
     sFrame = [UIScreen mainScreen].bounds;
     currentFrame = CGRectMake(0, 0, sFrame.size.width, sFrame.size.height);
     nextFrame = CGRectMake(0, sFrame.size.height, sFrame.size.width, sFrame.size.height);
    self.scrollView = [[UIScrollView alloc]initWithFrame:currentFrame];
    //self.scrollView.contentSize = CGSizeMake(sFrame.size.width, 1.5*sFrame.size.height);
    self.scrollView.delegate = self;
    _scrollView.alwaysBounceVertical = YES;
    
    _currentCustomCellRef = [[CustomCell alloc]initWithFrame:self.scrollView.frame];
    
    [self.scrollView addSubview:_currentCustomCellRef];
    if (count >1) {
        _nextCustomCellRef = [[CustomCell alloc]initWithFrame:nextFrame];
        [_scrollView addSubview:_nextCustomCellRef];
    }
    
    [self.view addSubview:_scrollView];
	// Do any additional setup after loading the view, typically from a nib.
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"%f",scrollView.contentOffset.y);
    //NSLog(@"%f",_nextCustomCellRef.frame.origin.y - scrollView.contentOffset.y);
    _nextCustomCellRef.frame = CGRectMake(_nextCustomCellRef.frame.origin.x, nextFrame.origin.y - scrollView.contentOffset.y , _nextCustomCellRef.frame.size.width, _nextCustomCellRef.frame.size.height);
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{

}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if(velocity.y >=0)
    {
        //[self scrollToNewPage:scrollView];
        //[self scrollToNewPageWithVelocity:velocity scrollView:scrollView];
    }
    //if fast enough ,just scroll it
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(!decelerate)
    {
        [self checkPage];
    }
}
- (void)checkPage
{
    //stick to new page
    if(_nextCustomCellRef.frame.origin.y + _scrollView.contentOffset.y <= currentIdx * sFrame.size.height * 0.5)
    {
        [self scrollToNewPage:_scrollView];
    }
    //back to the current page
    else
    {
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _nextCustomCellRef.frame = nextFrame; //CGRectMake(0, currentIdx * sFrame.size.height , currentFrame.size.width, currentFrame.size.height);
            
            _scrollView.contentOffset = CGPointMake(0,0);
        } completion:^(BOOL finished) {
        }];
    }
}
- (void)scrollToNewPage:(UIScrollView*)scrollView
{
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _nextCustomCellRef.frame = CGRectMake(0, currentIdx * sFrame.size.height , currentFrame.size.width, currentFrame.size.height);
    } completion:^(BOOL finished) {
    }];
}
- (void)scrollToNewPageWithVelocity:(CGPoint)velocity scrollView:(UIScrollView*)scrollView
{
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    animation.fromValue = @(_nextCustomCellRef.frame.origin.y);
    animation.toValue = @(currentIdx * sFrame.size.height);
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.duration = _nextCustomCellRef.frame.origin.y - currentIdx * sFrame.size.height;
    
    [_nextCustomCellRef.layer addAnimation:animation forKey:@"tester"];
}
@end
