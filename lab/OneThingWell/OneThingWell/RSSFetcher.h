//
//  RSSFetcher.h
//  OneThingWell
//
//  Created by Lanston Peng on 9/24/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RSSFetcherDelegate <NSObject>

@optional
- (void)didFinishFecthPosts:(NSArray*)result;
- (void)didFinishFecthImg:(NSIndexPath*)indexPath withImageData:(UIImage*)imgData;
- (void)didFinishFecthNewestPosts:(NSArray*)result;
@end


@interface RSSFetcher : NSObject

@property (strong,nonatomic)UIWindow* window;

@property (strong,nonatomic)id<RSSFetcherDelegate> delegate;

@property (strong,nonatomic)NSMutableArray* resultArr;

+(instancetype)singleton;

-(void)fetchRSSFeed:(void (^)(NSArray* arr))complete;

-(void)fetchNextPosts;

-(void)fetchNewestPosts;
@end
