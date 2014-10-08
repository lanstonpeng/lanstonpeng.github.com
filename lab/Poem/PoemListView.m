//
//  PoemListView.m
//  Poem
//
//  Created by Lanston Peng on 10/8/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "PoemListView.h"

@interface PoemListView()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation PoemListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuseListCell"];
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"reuseListCell"];
    UILabel* l = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    l.text = @"youku";
    [cell addSubview:l];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

@end
