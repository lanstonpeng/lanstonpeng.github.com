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

@property (strong,nonatomic)NSArray* allPoemData;

@end
@implementation PoemReader

#define JSONURL @"http://127.0.0.1:5000/static/poemdata.json"

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
    _allPoemData  = json;
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
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:JSONURL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"%@", json);
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
            }
            else
            {
                NSLog(@"no merging data caus duplicated data");
            }
            
        }
    }];
    [dataTask resume];
}

@end
