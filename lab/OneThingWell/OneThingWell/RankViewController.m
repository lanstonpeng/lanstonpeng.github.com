//
//  RankViewController.m
//  OneThingWell
//
//  Created by Lanston Peng on 9/25/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "RankViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "RankTableViewCell.h"
#import "WebPageViewController.h"

@interface RankViewController ()

@property (strong,nonatomic)NSArray* favDataArr;

@property (strong,nonatomic)UIActivityIndicatorView*  loadingView;

@property (nonatomic)BOOL isDone;
@end

static UIEdgeInsets rankTableViewOriginalInset;

@implementation RankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loadingView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.loadingView.frame = CGRectMake(self.view.frame.size.width/2 - self.loadingView.frame.size.width/2, self.view.frame.size.height -self.tabBarController.tabBar.frame.size.height, 20, 20);
    [self.view addSubview:self.loadingView];
    self.loadingView.hidden = YES;
    _isDone = YES;
    [self fetchFavTopData];
}

- (void)fetchFavTopData
{
    if(!_isDone)return;
    _isDone = NO;
    NSString *cql = [NSString stringWithFormat:@"select * from %@ limit 10 order by FavCount desc", @"AppTest"];
    [AVQuery doCloudQueryInBackgroundWithCQL:cql callback:^(AVCloudQueryResult *result, NSError *error) {
        self.favDataArr = result.results;
        [self.tableView reloadData];
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.contentInset = rankTableViewOriginalInset;
            self.loadingView.hidden = YES;
            [self.loadingView stopAnimating];
        }];
        _isDone = YES;
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    rankTableViewOriginalInset = self.tableView.contentInset;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _favDataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RankTableViewCell* cell = (RankTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"rankCell"];
    AVObject* obj = [_favDataArr objectAtIndex:indexPath.row];
    cell.webURLStr = [obj objectForKey:@"AppUrl"]?:@"http://lanstonpeng.github.io";
    cell.titleLabel.text = [obj objectForKey:@"Name"] ;
    cell.detailLabel.text = [[obj objectForKey:@"FavCount"] stringValue];
    
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showFavDetail"]) {
        WebPageViewController* controller = (WebPageViewController*)segue.destinationViewController;
        NSIndexPath* selectedIdxPath = [self.tableView indexPathForSelectedRow];
        controller.webpageURLString = [(RankTableViewCell*)[self.tableView cellForRowAtIndexPath:selectedIdxPath] webURLStr];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(scrollView.contentOffset.y < -rankTableViewOriginalInset.top - 100)
    {
        [self fetchFavTopData];
        self.loadingView.frame = CGRectMake(self.view.frame.size.width/2 - self.loadingView.frame.size.width/2, 30, self.loadingView.frame.size.width, self.loadingView.frame.size.height);
        [UIView animateWithDuration:0.3 animations:^{
            UIEdgeInsets edgeInset = UIEdgeInsetsMake(rankTableViewOriginalInset.top + 40, rankTableViewOriginalInset.left, rankTableViewOriginalInset.bottom , rankTableViewOriginalInset.right);
            scrollView.contentInset = edgeInset;
            self.loadingView.hidden = NO;
            [self.loadingView startAnimating];
        }];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
