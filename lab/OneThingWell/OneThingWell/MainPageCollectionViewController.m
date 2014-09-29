//
//  MainPageCollectionViewController.m
//  OneThingWell
//
//  Created by Lanston Peng on 9/29/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "MainPageCollectionViewController.h"
#import "AppCollectionViewCell.h"
#import "RSSFetcher.h"
#import "WebPageViewController.h"

@interface MainPageCollectionViewController ()<RSSFetcherDelegate>

@property (strong,nonatomic)RSSFetcher* fetcher;

@end

@implementation MainPageCollectionViewController

static NSString * const reuseIdentifier = @"reuseMainCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fetcher = [RSSFetcher singleton];
    self.fetcher.delegate = self;
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    
    // Do any additional setup after loading the view.
}
//- (void)viewDidLayoutSubviews
//{
//    [[self.collectionView visibleCells] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        AppCollectionViewCell* cell = (AppCollectionViewCell*)obj;
//        NSTextContainer* textContainer  = cell.appDescriptionTextView.textContainer;
//        NSLayoutManager* layoutManager = textContainer.layoutManager;
//        
//        CGRect textRect = [layoutManager usedRectForTextContainer:textContainer];
//        
//        UIEdgeInsets inset = UIEdgeInsetsZero;
//        inset.top = cell.appDescriptionTextView.bounds.size.height / 2 - textRect.size.height / 2;
//        cell.appDescriptionTextView.textContainerInset = inset;
//    }];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString: @"showCellDetail"])
    {
        NSIndexPath* selectedIdxPath = [[self.collectionView indexPathsForSelectedItems] firstObject];
        OneThingModel* model = (OneThingModel*)[RSSFetcher singleton].resultArr[selectedIdxPath.row];
        WebPageViewController* controller = (WebPageViewController*)segue.destinationViewController;
        controller.webpageURLString = model.appURL;
        //self.navigationController.navigationBar.alpha = 1;
    }
}

- (void)didFinishFecthPosts:(NSArray *)result
{
    [self.collectionView reloadData];
}

- (void)didFinishFecthImg:(NSIndexPath *)indexPath withImageData:(UIImage *)imgData
{
    NSArray* visiableIndexPaths = [self.collectionView indexPathsForVisibleItems];
    [visiableIndexPaths enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSIndexPath* item = (NSIndexPath*)obj;
        if (item.row == indexPath.row && item.section == indexPath.section) {
            //[tableViewController.tableView reloadRowsAtIndexPaths:@[idxPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [RSSFetcher singleton].resultArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AppCollectionViewCell *cell = (AppCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    OneThingModel* model = (OneThingModel*)[RSSFetcher singleton].resultArr[indexPath.row];
    cell.cellDataModel = model;
    [cell configureCellUI];
    [cell configureCellData];
    
    return cell;
}


#pragma mark <UICollectionViewDelegate>


/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
