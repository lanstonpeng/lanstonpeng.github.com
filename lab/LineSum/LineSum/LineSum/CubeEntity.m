//
//  CubeEntity.m
//  LineSum
//
//  Created by Lanston Peng on 4/18/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "CubeEntity.h"

@implementation CubeEntity

-(instancetype)initWithView:(UIView*)cubeView x:(int)x y:(int)y{
    if(self = [super init]){
        self.cubeView = cubeView;
        self.x = [NSNumber numberWithInt:x];
        self.y = [NSNumber numberWithInt:y];
        UILabel* numLabel = (UILabel*)[cubeView viewWithTag:LUCKY_NUM];
        self.score = numLabel.text;
    }
    return self;
}
@end
