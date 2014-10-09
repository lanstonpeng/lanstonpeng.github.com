//
//  PoemReader.m
//  Poem
//
//  Created by Lanston Peng on 6/2/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "PoemReader.h"
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import <AVOSCloud/AVOSCloud.h>

@interface PoemReader()
{
    NSString* _basePath;
    id<GAITracker> tracker;
}

@property (strong,nonatomic)NSMutableArray* allPoemData;

@end
@implementation PoemReader

#define JSONURL @"http://106.186.120.207:5000/static/poemdata.json"
#define ImageHost @"http://106.186.120.207:5000/static/images/%@.png"

+ (instancetype)sharedPoemReader
{
    static PoemReader* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [PoemReader new];
    });
    return instance;
}

- (void)fetchNewData
{
    AVQuery* query = [AVQuery queryWithClassName:@"status"];
    AVObject* item = [[query findObjects] firstObject];
    if ([[item objectForKey:@"hasNewPoem"] boolValue]) {
        [self getAllPoemsFromServer];
    }
    else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hasClickFiveStar"] boolValue]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self getAllPoemsFromServer];
        });
    }
}

-(void)getAllPoemsFromServer
{
    AVQuery* query = [AVQuery queryWithClassName:@"poem"];
    [query orderByDescending:@"updatedAt"];
    [query orderByDescending:@"isBonus"];
    __block NSMutableArray* releasePoemArr = [[NSMutableArray alloc]init];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [objects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            AVObject* item = (AVObject*)obj;
            if (![[item objectForKey:@"isDebug"]boolValue]) {
                [releasePoemArr addObject:item];
            }
            if ([[item objectForKey:@"isBonus"] boolValue]) {
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hasClickFiveStar"] boolValue]) {
                    [releasePoemArr addObject:item];
                }
            }
        }];
        self.poemListDataArr = [[NSArray alloc]initWithArray:releasePoemArr];
        releasePoemArr = nil;
        if([self.delegate respondsToSelector:@selector(AllPoemDidDownload:)]) {
            [self.delegate AllPoemDidDownload:self.poemListDataArr];
        }
    }];
    
}

-(NSArray*)getAllPoems
{
    tracker = [[GAI sharedInstance] defaultTracker];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString *filePath = [_basePath stringByAppendingString:@"/poemdata.json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSArray *json;
    if(data)
    {
         json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    }
    else{
        NSString *backUpfilePath = [[NSBundle mainBundle] pathForResource:@"poemdata_backup" ofType:@"json"];
        NSData *backUpdata = [NSData dataWithContentsOfFile:backUpfilePath];
        json = [NSJSONSerialization JSONObjectWithData:backUpdata options:kNilOptions error:nil];
    }
    _allPoemData  = [[NSMutableArray alloc]initWithArray: json];
    //NSLog(@"count:%d",_allPoemData.count);
    if([self isConnected])
    {
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"user_status"     // Event category (required)
                                                              action:@"network connect"  // Event action (required)
                                                               label:@""          // Event label
                                                               value:@(1)] build]];    // Event value
        [self getNewestPoemData];
    }
    else
    {
        
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"user_status"     // Event category (required)
                                                              action:@"network connect"  // Event action (required)
                                                               label:@""          // Event label
                                                               value:@(0)] build]];    // Event value
    }
    return json;
}
- (BOOL)isConnected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}
-(NSDictionary*)getPoemByID
{
    return @{};
}
-(void)getNewestPoemData
{
    NSURLSession* session = [NSURLSession sharedSession];
    NSOperationQueue* queue = [[NSOperationQueue alloc]init];
    
    [queue addOperationWithBlock:^{
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0
                                                            diskCapacity:0
                                                                diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
        NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:JSONURL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if(!error)
            {
                __block BOOL hasSameData = NO;
                [_allPoemData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if ([obj[@"id"] intValue] == [json[@"id"] intValue]) {
                        hasSameData = YES;
                        *stop = YES;
                    }
                }];
                if(!hasSameData){
                    //NSLog(@"merge data");
                    NSError* error;
                    NSMutableArray* newAllPoemData = [[NSMutableArray alloc]initWithArray:_allPoemData];
                    [newAllPoemData insertObject:json atIndex:0];
                    [self backUpCurrentPoemData];
                    
                    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newAllPoemData options:kNilOptions error:&error];
                    NSString* jsonPath = [_basePath stringByAppendingString:@"/poemdata.json"];
                    [jsonData writeToFile:jsonPath atomically:YES];
                    //NSLog(@"new path: %@",jsonPath);
                    //download image
                    [self downloadImage:json[@"bgimg"]];
                    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"database"     // Event category (required)
                                                                          action:@"merge data"  // Event action (required)
                                                                           label:@""          // Event label
                                                                           value:@(1)] build]];    // Event value
                }
                else
                {
                    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"database"     // Event category (required)
                                                                          action:@"no merging data"  // Event action (required)
                                                                           label:@""          // Event label
                                                                           value:@(1)] build]];    // Event value
                    NSLog(@"no merging data caus duplicated data");
                }
                
            }
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"net work status"     // Event category (required)
                                                                  action:@"connect"  // Event action (required)
                                                                   label:@"connection fails"          // Event label
                                                                   value:@(0)] build]];    // Event value
        }];
        [dataTask resume];
    }];
}

- (void)downloadImage:(NSString*)imageName
{
    
    NSURLSession* session = [NSURLSession sharedSession];
    NSOperationQueue* queue = [[NSOperationQueue alloc]init];
    
    [queue addOperationWithBlock:^{
        NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0
                                                                diskCapacity:0
                                                                    diskPath:nil];
        NSString* urlStr = [NSString stringWithFormat:ImageHost,imageName];
        
        [NSURLCache setSharedURLCache:sharedCache];
        NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:urlStr] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if(!error)
            {
                //NSString* pngPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/poem.bundle/"];
                NSString* pngPath  = [_basePath stringByAppendingString:[NSString stringWithFormat:@"/%@.png",imageName]];
                [data writeToFile:pngPath atomically:YES];
            }
        }];
        [dataTask resume];
    }];
}
- (void)backUpCurrentPoemData
{
    NSError* error;
    NSLog(@"backing up current poem data");
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:_allPoemData options:kNilOptions error:&error];
    NSString* jsonPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/poemdata_backup.json"];
    [jsonData writeToFile:jsonPath atomically:YES];
}
@end
