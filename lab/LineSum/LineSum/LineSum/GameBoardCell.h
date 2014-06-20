//
//  GameBoardCell.h
//  LineSum
//
//  Created by Sun Xi on 5/9/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameBoardCell : UIView

@property (nonatomic) int number;

@property (nonatomic) int desTag;

- (id)initWithFrame:(CGRect)frame andNum:(int)num;

@end
