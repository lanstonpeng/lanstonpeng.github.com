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
#import "AddNewAppViewController.h"

@interface MainPageCollectionViewController ()<RSSFetcherDelegate>

@property (strong,nonatomic)RSSFetcher* fetcher;

@property (strong,nonatomic)UIActivityIndicatorView*  loadingView;


@end

static int screenHeight = 0;
static UIEdgeInsets originalInset;
static CGRect navigatorBarFrame;


@implementation MainPageCollectionViewController
{
    CGFloat lastContentOffsetY;
}

static NSString * const reuseIdentifier = @"reuseMainCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fetcher = [RSSFetcher singleton];
    self.fetcher.delegate = self;
    self.loadingView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.loadingView.frame = CGRectMake(self.view.frame.size.width/2 - self.loadingView.frame.size.width/2, self.view.frame.size.height -self.tabBarController.tabBar.frame.size.height, 20, 20);
    navigatorBarFrame = self.navigationController.navigationBar.frame;
    [self.view addSubview:self.loadingView];
    self.loadingView.hidden = YES;
    screenHeight = (int)[UIScreen mainScreen].bounds.size.height;
    lastContentOffsetY = -9999999;
}
- (void)viewDidAppear:(BOOL)animated
{
    originalInset = self.collectionView.contentInset;
}

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
        self.navigationController.navigationBar.frame = navigatorBarFrame;
        //self.navigationController.navigationBar.alpha = 1;
    }
}

- (void)didFinishFecthPosts:(NSArray *)result
{
    [self.collectionView reloadData];
    [UIView animateWithDuration:0.3 animations:^{
        self.collectionView.contentInset = originalInset;
        self.loadingView.hidden = YES;
        [self.loadingView stopAnimating];
    }];
}

- (void)didFinishFecthImg:(NSIndexPath *)indexPath withImageData:(UIImage *)imgData
{
    NSArray* visiableIndexPaths = [self.collectionView indexPathsForVisibleItems];
    [visiableIndexPaths enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSIndexPath* item = (NSIndexPath*)obj;
        if (item.row == indexPath.row && item.section == indexPath.section) {
            //[tableViewController.tableView reloadRowsAtIndexPaths:@[idxPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        }
    }];
}

- (IBAction)recommendNewThing:(id)sender {
    AddNewAppViewController* addNewAppVC = [self.storyboard instantiateViewControllerWithIdentifier:@"newAppViewController"];
    [self presentViewController:addNewAppVC animated:YES completion:nil];
    //[self.navigationController presentViewController:addNewAppVC animated:YES completion:nil];
    //[self.navigationController pushViewController:addNewAppVC animated:YES];
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


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //I'll be back
    return;
    CGRect f = self.navigationController.navigationBar.frame;
    if (lastContentOffsetY == -9999999) {
        lastContentOffsetY = scrollView.contentOffset.y;
    }
    CGFloat deltaY = scrollView.contentOffset.y - lastContentOffsetY;
    NSLog(@"delta %f",deltaY);
    if (deltaY >= 0) {
        //NSLog(@"%f",scrollView.contentOffset.y);
        //self.navigationController.navigationBar.frame = CGRectMake(f.origin.x, f.origin.y, f.size.width, MAX(navigatorBarFrame.size.height -  scrollView.contentOffset.y, 0));
        self.navigationController.navigationBar.frame = CGRectMake(f.origin.x,MAX(-scrollView.contentOffset.y,navigatorBarFrame.origin.y - f.size.height) , f.size.width,f.size.height);
        //NSLog(@"-->%f",self.navigationController.navigationBar.frame.size.height);
    }
    else
    {
        self.navigationController.navigationBar.frame = CGRectMake(f.origin.x, navigatorBarFrame.origin.y, f.size.width, f.size.height);
    }
    lastContentOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(scrollView.contentOffset.y > 0 && scrollView.contentOffset.y > scrollView.contentSize.height - screenHeight + 100)
    {
        //inset scrollView
        [self.fetcher fetchNextPosts];
        [UIView animateWithDuration:0.3 animations:^{
            UIEdgeInsets edgeInset = UIEdgeInsetsMake(originalInset.top, originalInset.left, originalInset.bottom +  40, originalInset.right);
            scrollView.contentInset = edgeInset;
            self.loadingView.frame = CGRectMake(self.view.frame.size.width/2 - self.loadingView.frame.size.width/2, self.view.frame.size.height -self.tabBarController.tabBar.frame.size.height - 30, self.loadingView.frame.size.width, self.loadingView.frame.size.height);
            self.loadingView.hidden = NO;
            [self.loadingView startAnimating];
        }];
    }
    
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
