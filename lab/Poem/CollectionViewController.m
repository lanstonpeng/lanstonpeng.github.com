//
//  CollectionViewController.m
//  Poem
//
//  Created by Lanston Peng on 6/2/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "CollectionViewController.h"
#import "PoemReader.h"
#import "PoemDetailView.h"
#import "PoemIntroductionView.h"
#import "UIImage+PoemResouces.h"
#import "AppFunctionalityView.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"
#import "GAI.h"
#import <AVOSCloud/AVOSCloud.h>
#import "PoemCell.h"
#import "PoemListView.h"

@interface CollectionViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,PoemCellScrollDelegate,AppFunctionalityDelegate,PoemReaderDelegate,PoemListViewDelegate>
{
    NSMutableArray* poemArr;
    UIView* currentEmbedView;
    PoemTypeEnum currentPoemType;
    
    CGPoint dragStartPoint;
    CALayer* uppperShadow;
    CALayer* bottomShadow;
}
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIScrollView *poemMixedInfoScrollView;
@property (strong,nonatomic) PoemDetailView* poemDetailView;
@property (strong,nonatomic) PoemIntroductionView* introductionView;
@property (strong,nonatomic) PoemListView* poemListTableView;
@end


static CGRect sFrame;
@implementation CollectionViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.screenName = @"Poem Cell";
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
    sFrame = [UIScreen mainScreen].bounds;
    
    UIView* backgroundView = [[UIView alloc]initWithFrame:sFrame];
    UIImage* bgImg = (UIImage*)[[UIImage alloc]initWithName:@"black_linen_v2_@2X"];
    backgroundView.backgroundColor = [UIColor colorWithPatternImage:bgImg];
    [self.view addSubview:backgroundView];
    
    
    UICollectionViewFlowLayout* flowLayout = [[ UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    
    CGRect collectionViewFrame = CGRectOffset(sFrame, sFrame.size.width, 0);
    _collectionView = [[UICollectionView alloc]initWithFrame:collectionViewFrame collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.pagingEnabled = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.alpha = 0;
    
    
    
    _poemMixedInfoScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _poemMixedInfoScrollView.contentSize = CGSizeMake(self.view.frame.size.width*3, self.view.frame.size.height);
    _poemMixedInfoScrollView.tag = 100;
    _poemMixedInfoScrollView.delegate = self;
    _poemMixedInfoScrollView.pagingEnabled = YES;
    _poemMixedInfoScrollView.bounces = NO;
    _poemMixedInfoScrollView.showsHorizontalScrollIndicator = NO;
    _poemMixedInfoScrollView.contentOffset = CGPointMake(sFrame.size.width, 0);
    [_poemMixedInfoScrollView addSubview:_collectionView];
    
    
    
    [self.view addSubview:_poemMixedInfoScrollView];
    
    [_collectionView registerClass:[PoemCell class] forCellWithReuseIdentifier:@"reused"];
    
    PoemReader* reader = [PoemReader sharedPoemReader];
    reader.delegate = self;
    [reader getAllPoemsFromServer];
    
    
    CGRect poemDetailFrame = CGRectMake(self.view.frame.size.width*2, 0, self.view.frame.size.width * 2, self.view.frame.size.height);
    
    _poemListTableView = [[PoemListView alloc]initWithFrame:CGRectMake(0, 0, sFrame.size.width, sFrame.size.height)];
    _poemListTableView.listViewDelegate = self;
    [_poemMixedInfoScrollView addSubview:_poemListTableView];
    
    _poemDetailView = [[PoemDetailView alloc]initWithFrame:poemDetailFrame];
    [_poemMixedInfoScrollView addSubview:_poemDetailView];
    
    _introductionView = [[PoemIntroductionView alloc]initWithFrame:poemDetailFrame];
    [_poemMixedInfoScrollView addSubview:_introductionView];
    
    
    
    AppFunctionalityView* appFunctionalityView = [[AppFunctionalityView alloc]initWithFrame:CGRectMake(0, -70, sFrame.size.width, 50)];
    appFunctionalityView.delegate = self;
    [_collectionView addSubview:appFunctionalityView];
}

- (void)setupShadowLayer
{
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
}

- (void)AllPoemDidDownload:(NSArray *)poemDataArr
{
    poemArr = [[NSMutableArray alloc] initWithArray: poemDataArr];
    [self.collectionView reloadData];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset  = scrollView.contentOffset;
    if(offset.y < -60)
    {
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
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PoemCell* poemCell = (PoemCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"reused" forIndexPath:indexPath];
    _currentPoemCell = poemCell;
    poemCell.delegate = self;
    
    [poemCell setUpPoem:poemArr[indexPath.row]];;
    
    AVObject* item = (AVObject*)[poemArr objectAtIndex:indexPath.row];
    AVObject* img = [item objectForKey:@"imgPointer"];
    
    //TODO :show loading indicator
    [img fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        AVFile* file = (AVFile*)[object objectForKey:@"url"];
        [file getThumbnail:YES width:poemCell.frame.size.width height:poemCell.frame.size.height withBlock:^(UIImage *image, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                poemCell.bgView.image = image;
                //[poemCell startAnimation];
            });
        }];
//        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
//        } progressBlock:^(NSInteger percentDone) {
//        }];
    }];
    
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
    id tracker = [[GAI sharedInstance] defaultTracker];
    switch (cell.presentationType) {
        case PoemDetailType:
        {
            [_poemDetailView setPoemData:cell.poemData];
            [_poemMixedInfoScrollView bringSubviewToFront:_poemDetailView];
            currentEmbedView = _poemDetailView;
            currentPoemType = PoemDetailType;
            [tracker set:kGAIScreenName value:@"Poem Detail"];
            break;
        }
        case PoemIntroduction:
        {
            [_introductionView setPoemData:cell.poemData];
            [_poemMixedInfoScrollView bringSubviewToFront:_introductionView];
            currentEmbedView = _introductionView;
            currentPoemType = PoemIntroduction;
            [tracker set:kGAIScreenName value:@"Poem Introduction"];
            break;
        }
        case PoemList:
        {
            currentPoemType = PoemList;
            _poemListTableView.poemListDataArr = poemArr;
            NSIndexPath* currentIdxPath = [[self.collectionView indexPathsForVisibleItems] firstObject];
            _poemListTableView.currentIndexPath = currentIdxPath;
            [_poemListTableView reloadData];
            [tracker set:kGAIScreenName value:@"Poem List"];
        }
        default:
            break;
    }
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    _poemMixedInfoScrollView.scrollEnabled = NO;
}
- (void)poemCell:(PoemCell *)cell didChangePullOffset:(CGFloat)offset
{
    _poemMixedInfoScrollView.contentOffset = CGPointMake(sFrame.size.width + offset,0);
    //NSLog(@"contentoffset x %f",_poemMixedInfoScrollView.contentOffset.x);
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

#pragma PoemListViewDelegate
- (void)PoemListViewDidSelect:(NSIndexPath *)idxPath
{
    [UIView animateWithDuration:0.2 animations:^{
        self.poemMixedInfoScrollView.contentOffset = CGPointMake(sFrame.size.width, 0);
    } completion:^(BOOL finished) {
        [self.collectionView scrollToItemAtIndexPath:idxPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
    }];
}

@end
