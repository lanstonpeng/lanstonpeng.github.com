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

@interface PoemReader()

@property (strong,nonatomic)NSMutableArray* allPoemData;

@end
@implementation PoemReader

#define JSONURL @"http://127.0.0.1:5000/static/poemdata.json"
#define ImageHost @"http://127.0.0.1:5000/static/images/%@.png"

+ (instancetype)sharedPoemReader
{
    static PoemReader* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [PoemReader new];
    });
    return instance;
}
-(NSDictionary*)getRandomPoemReader
{
    return @{};
}
-(NSArray*)getAllPoems
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"poemdata" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    if (!json.count) {
        NSString *backUpfilePath = [[NSBundle mainBundle] pathForResource:@"poemdata_backup" ofType:@"json"];
        NSData *backUpdata = [NSData dataWithContentsOfFile:backUpfilePath];
        json = [NSJSONSerialization JSONObjectWithData:backUpdata options:kNilOptions error:nil];
    }
    _allPoemData  = [[NSMutableArray alloc]initWithArray: json];
    if([self isConnected])
    {
        [self getNewestPoemData];
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
                    NSLog(@"merge data");
                    NSError* error;
                    NSMutableArray* newAllPoemData = [[NSMutableArray alloc]initWithArray:_allPoemData];
                    [newAllPoemData insertObject:json atIndex:0];
                    [self backUpCurrentPoemData];
                    
                    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newAllPoemData options:kNilOptions error:&error];
                    NSString* jsonPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/poemdata.json"];
                    [jsonData writeToFile:jsonPath atomically:YES];
                    //download image
                    [self downloadImage:json[@"bgimg"]];
                }
                else
                {
                    NSLog(@"no merging data caus duplicated data");
                }
                
            }
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
                NSString* pngPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/poem.bundle/"];
                pngPath  = [pngPath stringByAppendingString:[NSString stringWithFormat:@"%@.png",imageName]];
                [data writeToFile:pngPath atomically:YES];
            }
        }];
        [dataTask resume];
    }];
}
- (void)backUpCurrentPoemData
{
    NSError* error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:_allPoemData options:kNilOptions error:&error];
    NSString* jsonPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/poemdata_backup.json"];
    [jsonData writeToFile:jsonPath atomically:YES];
}
@end
