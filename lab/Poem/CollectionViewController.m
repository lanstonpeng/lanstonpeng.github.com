//
//  CollectionViewController.m
//  Poem
//
//  Created by Lanston Peng on 6/2/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "CollectionViewController.h"
#import "PoemCell.h"

@interface CollectionViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,PoemCellDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
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
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[PoemCell class] forCellWithReuseIdentifier:@"reused"];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}

#pragma mark datasource and delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PoemCell* poemCell = (PoemCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"reused" forIndexPath:indexPath];
    poemCell.delegate = self;
    return poemCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return collectionView.bounds.size;
}

#pragma mark poemDelegate
- (void)didShowPoemDetail
{
    _collectionView.scrollEnabled = NO;
}
- (void)didHidePoemDetail
{
    _collectionView.scrollEnabled = YES;
}
@end
