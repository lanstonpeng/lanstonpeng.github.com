//
//  RSSFetcher.h
//  OneThingWell
//
//  Created by Lanston Peng on 9/24/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSSFetcher : NSObject

@property (strong,nonatomic)UIWindow* window;

+(instancetype)singleton;

-(void)fetchRSSFeed:(void (^)(NSArray* arr))complete;

-(void)fetchNextPosts;
@end
