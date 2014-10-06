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

@end

@implementation RankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *cql = [NSString stringWithFormat:@"select * from %@ limit 10 order by FavCount desc", @"AppTest"];
    [AVQuery doCloudQueryInBackgroundWithCQL:cql callback:^(AVCloudQueryResult *result, NSError *error) {
        self.favDataArr = result.results;
        [self.tableView reloadData];
    }];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
