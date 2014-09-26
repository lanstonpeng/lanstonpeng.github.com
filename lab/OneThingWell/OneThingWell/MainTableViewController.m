//  MainTableViewController.m
//  OneThingWell
//
//  Created by Lanston Peng on 9/24/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "MainTableViewController.h"
#import "CustomTableViewCell.h"
#import "OneThingModel.h"
#import "WebPageViewController.h"
#import "RSSFetcher.h"

#define maxScrollToHide 50
#define barHeight 44

static int screenHeight = 0;

@interface MainTableViewController ()<RSSFetcherDelegate>

@property (strong,nonatomic)RSSFetcher* fetcher;

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    screenHeight = (int)[UIScreen mainScreen].bounds.size.height;
    self.fetcher = [RSSFetcher singleton];
    self.fetcher.delegate = self;
    
    UISwipeGestureRecognizer* swipeFromRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeRight:)];
    swipeFromRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.tableView addGestureRecognizer:swipeFromRight];
    
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    //self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLayoutSubviews
{
    
}

- (void)viewWillLayoutSubviews
{
    //self.navigationController.navigationBar.frame = CGRectOffset(self.navigationController.navigationBar.frame, 0, -20);
}

- (void)handleSwipeRight:(UIGestureRecognizer*)gesture
{
    CGPoint location = [gesture locationInView:self.tableView];
    NSIndexPath* indexPath = [self.tableView indexPathForRowAtPoint:location];
    if(indexPath)
    {
        CustomTableViewCell* cell = (CustomTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.result.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = (CustomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"reuseCell" forIndexPath:indexPath];
    
    OneThingModel* model = (OneThingModel*)self.result[indexPath.row];
    cell.title.text = model.appName;
    cell.row = indexPath.row;
    cell.pubTime.text = model.pubTimeStr;
    
    if (model.appDescription.length > 0) {
        cell.textView.text = model.appDescription;
//        NSMutableAttributedString* atrStr = [[NSMutableAttributedString alloc]initWithString:model.appDescription];
//        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        cell.textBackgroundAlpahView.hidden = NO;
    }
    else
    {
        cell.textView.text = @"";
        cell.textBackgroundAlpahView.hidden = YES;
    }
    if (model.screenShoot) {
        cell.backgroundImageView.image =  model.screenShoot;
        cell.backgroundAlphaView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    }
    else{
        cell.backgroundImageView.image =  nil;
        cell.backgroundAlphaView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    }
    //[cell.textView removeObserver:self forKeyPath:@"contentSize"];
    return cell;
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([segue.identifier isEqualToString: @"showAppURL"])
    {
        NSIndexPath* selectedIdxPath = [self.tableView indexPathForSelectedRow];
        OneThingModel* model = (OneThingModel*)self.result[selectedIdxPath.row];
        WebPageViewController* controller = (WebPageViewController*)segue.destinationViewController;
        controller.webpageURLString = model.appURL;
        //self.navigationController.navigationBar.hidden = NO;
        self.navigationController.navigationBar.alpha = 1;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //CGRect frame = self.navigationController.navigationBar.frame;
    //NSLog(@"%f",scrollView.contentOffset.y);
    if(scrollView.contentOffset.y  > maxScrollToHide)
    {
        //self.navigationController.navigationBar.hidden = YES;
    }
    else{
        //self.navigationController.navigationBar.hidden = NO;
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(scrollView.contentOffset.y > 0 && scrollView.contentOffset.y > scrollView.contentSize.height - screenHeight + 100)
    {
        //inset scrollView
//        [UIView animateWithDuration:0.3 animations:^{
//            UIEdgeInsets edgeInset = UIEdgeInsetsMake(0, 0, 20, 0);
//            scrollView.contentInset = edgeInset;
//        }];
        [_fetcher fetchNextPosts];
    }
    
}

- (void)didFinishFecthPosts:(NSArray *)result
{
//    [UIView animateWithDuration:0.3 animations:^{
//        UIEdgeInsets edgeInset = UIEdgeInsetsMake(0, 0, 0, 0);
//        self.tableView.contentInset = edgeInset;
//    }];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
