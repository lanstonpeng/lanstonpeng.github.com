//
//  CollectionViewController.m
//  Poem
//
//  Created by Lanston Peng on 6/2/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "CollectionViewController.h"
#import "PoemReader.h"
#import "CustomTestCell.h"
#import "PoemDetailView.h"
#import "PoemIntroductionView.h"
#import "UIImage+PoemResouces.h"
#import "AppFunctionalityView.h"
//#import "LoadingView.h"

@interface CollectionViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,PoemCellScrollDelegate,AppFunctionalityDelegate>
{
    NSMutableArray* poemArr;
    UIView* currentEmbedView;
    PoemTypeEnum currentPoemType;
    
    CGPoint dragStartPoint;
    CALayer* uppperShadow;
    CALayer* bottomShadow;
    
    //LoadingView* loadingView;
}
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIScrollView *poemMixedInfoScrollView;
@property (strong,nonatomic) PoemDetailView* poemDetailView;
@property (strong,nonatomic)PoemIntroductionView* introductionView;
@end

@implementation CollectionViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.screenName = @"CollectionView Controller";
    [self.delegate collectionViewWillAppear];
    [UIView animateWithDuration:0.6 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _collectionView.alpha = 1;
    } completion:^(BOOL finished) {
    }];
    _poemMixedInfoScrollView.contentInset = UIEdgeInsetsZero;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"CollectionView did load");
    //loadingView = [[LoadingView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    //[self.view addSubview:loadingView];
    // Do any additional setup after loading the view.
    CGRect sFrame = [UIScreen mainScreen].bounds;
    self.view = [[UIView alloc]initWithFrame:sFrame];
    
    UIView* backgroundView = [[UIView alloc]initWithFrame:sFrame];
    UIImage* bgImg = (UIImage*)[[UIImage alloc]initWithName:@"black_linen_v2_@2X"];
    backgroundView.backgroundColor = [UIColor colorWithPatternImage:bgImg];
    [self.view addSubview:backgroundView];
    
    
    UICollectionViewFlowLayout* flowLayout = [[ UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.pagingEnabled = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.alpha = 0;
    
    
    
    _poemMixedInfoScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _poemMixedInfoScrollView.contentSize = CGSizeMake(self.view.frame.size.width*2, self.view.frame.size.height);
    _poemMixedInfoScrollView.tag = 100;
    _poemMixedInfoScrollView.delegate = self;
    _poemMixedInfoScrollView.pagingEnabled = YES;
    _poemMixedInfoScrollView.bounces = NO;
    _poemMixedInfoScrollView.showsHorizontalScrollIndicator = NO;
    [_poemMixedInfoScrollView addSubview:_collectionView];
    
    
    
    [self.view addSubview:_poemMixedInfoScrollView];
    
    [_collectionView registerClass:[PoemCell class] forCellWithReuseIdentifier:@"reused"];
    
    PoemReader* reader = [PoemReader sharedPoemReader];
    poemArr = (NSMutableArray*)[reader getAllPoems];
    CGRect poemDetailFrame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width * 2, self.view.frame.size.height);
    _poemDetailView = [[PoemDetailView alloc]initWithFrame:poemDetailFrame];
    [_poemMixedInfoScrollView addSubview:_poemDetailView];
    
    _introductionView = [[PoemIntroductionView alloc]initWithFrame:poemDetailFrame];
    [_poemMixedInfoScrollView addSubview:_introductionView];
    
    uppperShadow = [CALayer layer];
    uppperShadow.shadowOffset = CGSizeMake(0, -3);
    uppperShadow.backgroundColor= [UIColor orangeColor].CGColor;
    uppperShadow.shadowPath = [[UIBezierPath bezierPathWithRect:CGRectMake(-2, -1, 330, 4)]  CGPath];
    uppperShadow.shadowRadius = 4.0f;
    [uppperShadow setShadowColor:[UIColor blackColor].CGColor];
    [uppperShadow setShadowOpacity:0.8];
    [_collectionView.layer addSublayer:uppperShadow];
    
    bottomShadow = [CALayer layer];
    bottomShadow.shadowOffset = CGSizeMake(0, -1);
    bottomShadow.backgroundColor= [UIColor orangeColor].CGColor;
    bottomShadow.shadowPath = [[UIBezierPath bezierPathWithRect:CGRectMake(-2, poemArr.count * self.view.frame.size.height - 1, 330, 4)]  CGPath];
    bottomShadow.shadowRadius = 3.0f;
    [bottomShadow setShadowColor:[UIColor blackColor].CGColor];
    [bottomShadow setShadowOpacity:0.8];
    [_collectionView.layer addSublayer:bottomShadow];
    
    AppFunctionalityView* appFunctionalityView = [[AppFunctionalityView alloc]initWithFrame:CGRectMake(0, -70, sFrame.size.width, 50)];
    appFunctionalityView.delegate = self;
    [_collectionView addSubview:appFunctionalityView];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset  = scrollView.contentOffset;
    if(offset.y < -60)
    {
        //scrollView.contentOffset = CGPointMake(0, -70);
        //Confusing
        scrollView.contentInset =  UIEdgeInsetsMake(70, 0, 0, 0);
        if(offset.y < -260)
        {
            scrollView.contentOffset = CGPointMake(0, -260);
        }
    }
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(decelerate && scrollView.contentOffset.x - dragStartPoint.x == 0)
    {
        switch (currentPoemType) {
            case PoemDetailType:
            {
                //[_poemDetailView showToolBarView];
                break;
            }
            case PoemIntroduction:
            {
                break;
            }
            default:
                break;
        }
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    dragStartPoint = scrollView.contentOffset;
}
#pragma mark datasource and delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return poemArr.count;
    //return 5;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PoemCell* poemCell = (PoemCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"reused" forIndexPath:indexPath];
    _currentPoemCell = poemCell;
    poemCell.delegate = self;
    
    [poemCell setUpPoem:poemArr[indexPath.row]];;
    return poemCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return collectionView.bounds.size;
}
- (void)clearScrollSubView
{
    if(currentEmbedView)
    {
        [currentEmbedView removeFromSuperview];
    }
}
#pragma mark poemDelegate
- (void)poemCellDidBeginPulling:(PoemCell *)cell
{
    //[self clearScrollSubView];
    switch (cell.presentationType) {
        case PoemDetailType:
        {
            [_poemDetailView setPoemData:cell.poemData];
//            _poemDetailView.layer.zPosition = 1;
//            _introductionView.layer.zPosition = 0;
            //[_poemMixedInfoScrollView addSubview:_poemDetailView];
            [_poemMixedInfoScrollView bringSubviewToFront:_poemDetailView];
            currentEmbedView = _poemDetailView;
            currentPoemType = PoemDetailType;
            break;
        }
        case PoemIntroduction:
        {
            [_introductionView setPoemData:cell.poemData];
            [_poemMixedInfoScrollView bringSubviewToFront:_introductionView];
            //[_poemMixedInfoScrollView addSubview:_introductionView];
//            _poemDetailView.layer.zPosition = 0;
//            _introductionView.layer.zPosition = 1;
            currentEmbedView = _introductionView;
            currentPoemType = PoemIntroduction;
            break;
        }
        default:
            break;
    }
    _poemMixedInfoScrollView.scrollEnabled = NO;
}
- (void)poemCell:(PoemCell *)cell didChangePullOffset:(CGFloat)offset
{
    _poemMixedInfoScrollView.contentOffset = CGPointMake(offset,0);
}
-(void)poemCellDidEndPulling:(PoemCell *)cell
{
    _poemMixedInfoScrollView.scrollEnabled = YES;
}

#pragma mark appFunctionalityView delegate
- (void)MailDidDismiss
{
    _poemMixedInfoScrollView.contentInset = UIEdgeInsetsZero;
}

@end
