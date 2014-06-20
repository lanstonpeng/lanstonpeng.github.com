//
//  CubeEntity.h
//  LineSum
//
//  Created by Lanston Peng on 4/18/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import <Foundation/Foundation.h>
#define LUCKY_NUM 806

@interface CubeEntity : NSObject
@property (strong,nonatomic)UIView* cubeView;
@property (strong,nonatomic)NSNumber* x;
@property (strong,nonatomic)NSNumber* y;
@property (strong,nonatomic)NSString* score;
-(instancetype)initWithView:(UIView*)cubeView x:(int)x y:(int)y;
@end
