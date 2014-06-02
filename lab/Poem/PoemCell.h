//
//  PoemCell.h
//  Poem
//
//  Created by Lanston Peng on 6/2/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PoemCellDelegate <NSObject>

- (void)didShowPoemDetail;
- (void)didHidePoemDetail;

@end

@interface PoemCell : UICollectionViewCell
@property (weak,nonatomic)id<PoemCellDelegate> delegate;
@end

