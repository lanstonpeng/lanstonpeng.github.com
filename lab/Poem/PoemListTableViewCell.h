//
//  PoemListTableViewCell.h
//  Poem
//
//  Created by Lanston Peng on 10/8/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>

@interface PoemListTableViewCell : UITableViewCell

@property (strong,nonatomic)UILabel* titleLabel;

@property (strong,nonatomic)UILabel* authorLabel;

@property (strong,nonatomic)UIImageView* bgImageView;


- (void)configureCell:(AVObject*)item withIdxPath:(NSIndexPath*)idxPath;
- (void)setHighlightCell;
- (void)setDefaultHightlightCell;
@end
