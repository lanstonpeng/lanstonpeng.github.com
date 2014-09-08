//
//  TestCollection.h
//  ProjectBlackSwan
//
//  Created by Lanston Peng on 9/1/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestCollection : NSObject

+(instancetype)singleton;

- (NSArray*)getTestCollectionArr;

- (void)addTestCollectionObj:(NSObject*)obj;

- (NSArray*)getTestCollectionArrNSThread;

- (void)addTestCollectionObjNSTHread:(NSObject*)obj;
@end
