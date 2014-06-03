//
//  PoemCell.h
//  Poem
//
//  Created by Lanston Peng on 6/2/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PoemCellScrollDelegate;


#define MaxScrollPull 60
@interface PoemCell : UICollectionViewCell
@property (weak,nonatomic)id<PoemCellScrollDelegate> delegate;

- (void)setUpPoem:(NSDictionary*)poem;
@end

@protocol PoemCellScrollDelegate <NSObject>

- (void)poemCellDidBeginPulling:(PoemCell*)cell;
- (void)poemCell:(PoemCell*)cell didChangePullOffset:(CGFloat)offset;
- (void)poemCellDidEndPulling:(PoemCell*)cell;

@end

