//
//  CollectionViewController.m
//  Poem
//
//  Created by Lanston Peng on 6/2/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "CollectionViewController.h"
#import "PoemCell.h"
#import "PoemReader.h"
#import "CustomTestCell.h"
#import "PoemDetailView.h"
#import "PoemIntroductionView.h"

@interface CollectionViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,PoemCellScrollDelegate>
{
    NSMutableArray* poemArr;
    UIView* currentEmbedView;
}
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIScrollView *poemMixedInfoScrollView;
@end

@implementation CollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    UICollectionViewFlowLayout* flowLayout = [[ UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor orangeColor];
    //_collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.pagingEnabled = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    _poemMixedInfoScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _poemMixedInfoScrollView.contentSize = CGSizeMake(self.view.frame.size.width*2, self.view.frame.size.height);
    _poemMixedInfoScrollView.tag = 100;
    _poemMixedInfoScrollView.delegate = self;
    _poemMixedInfoScrollView.pagingEnabled = YES;
    _poemMixedInfoScrollView.showsHorizontalScrollIndicator = NO;
    [_poemMixedInfoScrollView addSubview:_collectionView];
    
    [self.view addSubview:_poemMixedInfoScrollView];
    
    [_collectionView registerClass:[PoemCell class] forCellWithReuseIdentifier:@"reused"];
    //[_collectionView registerClass:[CustomTestCell class] forCellWithReuseIdentifier:@"reused"];
    
    PoemReader* reader = [PoemReader sharedPoemReader];
    poemArr = (NSMutableArray*)[reader getAllPoems];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"collection did scroll");
    if (scrollView.tag == 100) {
        
    }
    else
    {
        
    }
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
    poemCell.delegate = self;
    
    [poemCell setUpPoem:poemArr[indexPath.row]];;
    return poemCell;
    /*
    CustomTestCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reused" forIndexPath:indexPath];
    CGFloat hue = (CGFloat)indexPath.row / 5;
    cell.backgroundColor = [UIColor
                            colorWithHue:hue saturation:1.0f brightness:0.5f alpha:1.0f
                            ];
    return cell;
     */
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
    [self clearScrollSubView];
    switch (cell.presentationType) {
        case PoemDetailType:
        {
            CGRect poemDetailFrame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width * 2, self.view.frame.size.height);
            PoemDetailView* poemDetailView = [[PoemDetailView alloc]initWithFrame:poemDetailFrame withData:cell.poemData];
            [_poemMixedInfoScrollView addSubview:poemDetailView];
            currentEmbedView = poemDetailView;
            break;
        }
        case PoemIntroduction:
        {
            CGRect poemDetailFrame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width * 2, self.view.frame.size.height);
            PoemIntroductionView* introudctionView = [[PoemIntroductionView alloc]initWithFrame:poemDetailFrame withData:cell.poemData];
            [_poemMixedInfoScrollView addSubview:introudctionView];
            currentEmbedView = introudctionView;
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
@end
