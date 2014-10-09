//
//  PoemListView.m
//  Poem
//
//  Created by Lanston Peng on 10/8/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//
#import "PoemListView.h"
#import "PoemListTableViewCell.h"
#import <AVOSCloud/AVOSCloud.h>
#import "UIImage+PoemResouces.h"

@interface PoemListView()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation PoemListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self registerClass:[PoemListTableViewCell class] forCellReuseIdentifier:@"reuseListCell"];
        self.delegate = self;
        self.dataSource = self;
        UIImage* bgImg = (UIImage*)[[UIImage alloc]initWithName:@"black_linen_v2_@2X"];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundView = [[UIImageView alloc]initWithImage:bgImg];
        //self.backgroundColor = [UIColor grayColor];
    }
    return self;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PoemListTableViewCell* cell = (PoemListTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"reuseListCell"];
    
    AVObject* item = (AVObject*)[self.poemListDataArr objectAtIndex:indexPath.row];
    [cell configureCell:item withIdxPath:indexPath];
    if (indexPath.row == _currentIndexPath.row) {
        [cell setHighlightCell];
    }
    else
    {
        [cell setDefaultHightlightCell];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.listViewDelegate PoemListViewDidSelect:indexPath];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.poemListDataArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

@end
