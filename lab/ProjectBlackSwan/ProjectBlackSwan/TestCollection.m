//
//  TestCollection.m
//  ProjectBlackSwan
//
//  Created by Lanston Peng on 9/1/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "TestCollection.h"

@interface TestCollection()

@property (strong,nonatomic)NSMutableArray* arr;

@property (nonatomic, strong) dispatch_queue_t concurrentPhotoQueue;

@property (strong,nonatomic)NSLock* lock;
@end



@implementation TestCollection

+(instancetype)singleton{
    
    static TestCollection* tc = nil;
    static dispatch_once_t token;
    
    dispatch_once(&token,^{
        tc = [[TestCollection alloc]init];
        tc.arr = [NSMutableArray new];
        tc.concurrentPhotoQueue = dispatch_queue_create("com.test.obj.queue", DISPATCH_QUEUE_CONCURRENT);
        tc.lock = [[NSLock alloc]init];
    });
    return tc;
}

- (NSArray*)getTestCollectionArr{
    __block NSArray* newArr;
    
    dispatch_sync(_concurrentPhotoQueue, ^{
        newArr = [NSArray arrayWithArray:_arr];
    });
    NSLog(@"%@",newArr);
    return newArr;
}

- (void)addTestCollectionObj:(NSObject*)obj{
    if (obj) {
        dispatch_barrier_async(_concurrentPhotoQueue, ^{
            [_arr addObject:obj];
            //NSLog(@"_arr : %@",_arr);
        });
    }
}

//- (NSArray*)getTestCollectionArrNSThread{
//    
//}

- (void)addTestCollectionObjNSTHread:(NSObject*)obj{
    
}
@end
