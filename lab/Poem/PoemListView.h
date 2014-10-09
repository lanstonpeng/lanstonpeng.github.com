//
//  PoemListView.h
//  Poem
//
//  Created by Lanston Peng on 10/8/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PoemListViewDelegate <NSObject>

- (void)PoemListViewDidSelect:(NSIndexPath*)idxPath;

@end

@interface PoemListView : UITableView

@property (strong,nonatomic)NSArray* poemListDataArr;

@property (strong,nonatomic)NSIndexPath* currentIndexPath;

@property (weak,nonatomic)id<PoemListViewDelegate> listViewDelegate;

@end

