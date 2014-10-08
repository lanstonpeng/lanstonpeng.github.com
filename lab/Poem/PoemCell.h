//
//  PoemCell.h
//  Poem
//
//  Created by Lanston Peng on 6/2/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum
{
    PoemDetailType = 0,
    PoemIntroduction,
    PoemList
}PoemTypeEnum;

@protocol PoemCellScrollDelegate;


#define MaxScrollPull 80
@interface PoemCell : UICollectionViewCell
@property (weak,nonatomic)id<PoemCellScrollDelegate> delegate;
@property (strong,nonatomic)NSDictionary* poemData;
@property (nonatomic)PoemTypeEnum presentationType;
@property (strong,nonatomic)UIImageView* bgView;

- (void)setUpPoem:(NSDictionary*)poem;
- (void)startAnimation;
- (void)stopAnimation;
@end

@protocol PoemCellScrollDelegate <NSObject>

- (void)poemCellDidBeginPulling:(PoemCell*)cell;
- (void)poemCell:(PoemCell*)cell didChangePullOffset:(CGFloat)offset;
- (void)poemCellDidEndPulling:(PoemCell*)cell;
@end

