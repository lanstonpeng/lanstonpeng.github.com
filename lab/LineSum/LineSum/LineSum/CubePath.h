//
//  CubePath.h
//  LineSum
//
//  Created by Lanston Peng on 4/18/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CubeEntity.h"

@interface CubePath : NSObject
@property (strong,nonatomic)NSMutableArray* cubePathArray;
-(void)addCubeEntity:(CubeEntity*)cubeEntity;
-(void)removeLastCubeView;
-(BOOL)containCubePath:(CubeEntity*)cubeEntity;
-(BOOL)isEqualToLastObject:(CubeEntity*)cubeEntity;
-(void)revertPathAfterCubeView:(CubeEntity*)cubeEntity executeBlokOnRevertedItem:(void (^)(CubeEntity* cubeEntity))executeBlock includingBeginItem:(BOOL)isIncluded;
@end
