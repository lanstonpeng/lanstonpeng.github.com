//
//  RSSFetcher.m
//  OneThingWell
//
//  Created by Lanston Peng on 9/24/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "RSSFetcher.h"
#import "XMLDictionary.h"
#import "MainTableViewController.h"
#import "TMAPIClient.h"
#import "HTMLReader.h"
#import "OneThingModel.h"
#import "AppDataManipulator.h"

@interface RSSFetcher()<NSURLSessionDownloadDelegate>

@property (nonatomic, copy) void (^completeBlock)(NSArray*);

@property (nonatomic)int currentOffset;

@property (nonatomic)BOOL isDone;

@property (strong,nonatomic)NSMutableDictionary* urlPicDic;

@property (strong,nonatomic)NSOperationQueue* downloadQueue;
@end

#define kLimitNumber  @5
#define kThumblrURL @"onethingwell.tumblr.com"

static UIWindow* privateWindow;

@implementation RSSFetcher

- (void)setWindow:(UIWindow *)window
{
    //static dispatch_once_t windowToken;
    //dispatch_once(&windowToken, ^{
    //});
    privateWindow = window;
}

+(instancetype)singleton{
    static dispatch_once_t token;
    static RSSFetcher* rssFetcher;
    dispatch_once(&token, ^{
        rssFetcher = [[RSSFetcher alloc]init];
        rssFetcher.currentOffset = 0;
        rssFetcher.isDone = YES;
        rssFetcher.urlPicDic = [NSMutableDictionary new];
        rssFetcher.downloadQueue = [[NSOperationQueue alloc]init];
        rssFetcher.downloadQueue.maxConcurrentOperationCount = 3;
        rssFetcher.resultArr = [NSMutableArray new];
    });
    return rssFetcher;
}
-(void)fetchRSSFeed:(void (^)(NSArray* arr))complete
{
    self.completeBlock = complete;
    NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://onethingwell.org/rss"]];
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        XMLDictionaryParser* xmlDictionary = [[XMLDictionaryParser alloc]init];
        NSDictionary* xmlData = [xmlDictionary dictionaryWithData:data];
        NSArray* result = xmlData[@"channel"][@"item"];
        complete(result);
    }];
    [task resume];
}

-(void)fetchCurrentSectionPosts{
    self.currentOffset = 0;
}
- (void)fetchNextPosts
{
    if (!_isDone) {
        return;
    }
    self.isDone = NO;
    // Authenticate via API Key
    [TMAPIClient sharedInstance].OAuthConsumerKey = @"Cw7HrjgYLdMkLXW8TEW1kZ75eMYKIw1AI5WHWy7NZ3H2mstSmE";
    
    // Make the request
    [[TMAPIClient sharedInstance] posts:kThumblrURL
                                   type:nil
                             parameters:@{ @"limit" : kLimitNumber,
                                           @"offset" : @(self.currentOffset)
                                           }
                               callback:^ (id result, NSError *error) {
                                   NSDictionary* dic = (NSDictionary*)result;
                                   NSArray* arr = dic[@"posts"];
                                   
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       MainTableViewController* tableViewController = [self getMainViewController];
                                       
                                       NSMutableArray* result = [NSMutableArray new];
                                       NSMutableArray* idxPaths = [NSMutableArray new];
                                       __block NSUInteger currentRow = self.resultArr.count;
                                       
                                       
                                       [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                           NSIndexPath* idxPath = [NSIndexPath indexPathForRow:currentRow++ inSection:0];
                                           [idxPaths addObject:idxPath];
                                           OneThingModel* item = [OneThingModel new];
                                           item.appName = (NSString*)obj[@"title"];
                                           item.appURL = (NSString*)obj[@"url"];
                                           NSString* pubStr =[(NSString*)obj[@"date"] componentsSeparatedByString:@" "][0];
                                           item.pubTimeStr = pubStr;
                                           item.tags = (NSArray*)obj[@"tags"];
                                           item.appID = [obj[@"id"] stringValue];
                                           
                                           item.isFav = [[AppDataManipulator singleton]isInLocalFav:item.appID];
                                           
                                           
                                           NSString* des = (NSString*)obj[@"description"];
                                           des = des?:@"";
                                           
                                           HTMLDocument *document = [HTMLDocument documentWithString:des];
                                           item.appDescription = [document firstNodeMatchingSelector:@"p"].textContent;
                                           
                                           //someone has already upload an screenshot
                                           if ([document firstNodeMatchingSelector:@"img"].attributes[@"src"]) {
                                               dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                   NSString* imgURL = [document firstNodeMatchingSelector:@"img"].attributes[@"src"];
                                                   NSURL* url = [NSURL URLWithString:imgURL];
                                                   NSData* imgData = [NSData dataWithContentsOfURL:url];
                                                   item.screenShoot = [UIImage imageWithData:imgData];
                                                   
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       MainTableViewController* tableViewController = [self getMainViewController];
                                                       if (tableViewController == nil) {
                                                           return;
                                                       }
                                                       NSArray* visiableIndexPaths = [tableViewController.tableView indexPathsForVisibleRows];
                                                       NSIndexPath* idxPath = [NSIndexPath indexPathForItem:idx inSection:0];
                                                       
                                                       [visiableIndexPaths enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                                           NSIndexPath* item = (NSIndexPath*)obj;
                                                           if (item.row == idxPath.row && item.section == idxPath.section) {
                                                               [tableViewController.tableView reloadRowsAtIndexPaths:@[idxPath] withRowAnimation:UITableViewRowAnimationFade];
                                                           }
                                                       }];
                                                   });
                                               });
                                           }
                                           //otherwise we fetch the first image from the app website
                                           else
                                           {
                                               [self.urlPicDic setObject:@{
                                                                           @"idx":@(currentRow - 1)
                                                                           } forKey:item.appURL];
                                               [self getAppWebSiteImage:item.appURL];
                                           }
                                           
                                           [result addObject:item];
                                       }];
                                       /*
                                       if (tableViewController.result.count > 0)
                                       {
                                           [tableViewController.result addObjectsFromArray:result];
                                       }
                                       else
                                       {
                                           tableViewController.result = result;
                                       }
                                        */
                                       if (self.resultArr.count > 0 ) {
                                           [self.resultArr addObjectsFromArray:result];
                                       }
                                       else
                                       {
                                           self.resultArr = result;
                                       }
                                       
                                       UITableView* tableView = tableViewController.tableView;
                                       [tableView reloadData];
                                       //[tableView insertRowsAtIndexPaths:idxPaths withRowAnimation:UITableViewRowAnimationFade];
                                       self.currentOffset += 10;
                                       self.isDone = YES;
                                       
                                       if ([self.delegate respondsToSelector:@selector(didFinishFecthPosts:)]) {
                                           [self.delegate performSelector:@selector(didFinishFecthPosts:) withObject:result];
                                       }
                                   });
                               }];

}

- (void)getAppWebSiteImage:(NSString*)urlStr
{
    NSURL* url = [NSURL URLWithString:urlStr];
    NSURLSessionConfiguration* configure = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:configure delegate:self delegateQueue:self.downloadQueue];
    NSURLSessionDownloadTask* downloadTask = [session downloadTaskWithRequest:[NSURLRequest requestWithURL:url]];
    [downloadTask resume];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSData* data = [NSData dataWithContentsOfURL:location];
    NSString* html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    HTMLDocument *document = [HTMLDocument documentWithString:html];
    if ([document firstNodeMatchingSelector:@"img"].attributes[@"src"]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSString* imgURL = [document firstNodeMatchingSelector:@"img"].attributes[@"src"];
            if ([imgURL componentsSeparatedByString:@"http"].count < 2) {
                imgURL = [downloadTask.originalRequest.URL.absoluteString stringByAppendingString:imgURL];
            }
            NSURL* url = [NSURL URLWithString:imgURL];
            NSData* imgData = [NSData dataWithContentsOfURL:url];
            if (imgData) {
                NSDictionary* dic = self.urlPicDic[downloadTask.originalRequest.URL.absoluteString];
                int idx = (int)[[dic objectForKey:@"idx"]integerValue];
                OneThingModel* model = (OneThingModel*)[self.resultArr objectAtIndex:idx];
                model.screenShoot = [UIImage imageWithData:imgData];
                //update UITableView
                MainTableViewController* tableViewController = [self getMainViewController];
                if (tableViewController == nil) {
                    return;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    MainTableViewController* tableViewController = [self getMainViewController];
                    if (tableViewController == nil) {
                        return;
                    }
                    NSArray* visiableIndexPaths = [tableViewController.tableView indexPathsForVisibleRows];
                    NSIndexPath* idxPath = [NSIndexPath indexPathForItem:idx inSection:0];
                    
                    [visiableIndexPaths enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        NSIndexPath* item = (NSIndexPath*)obj;
                        if (item.row == idxPath.row && item.section == idxPath.section) {
                            [tableViewController.tableView reloadRowsAtIndexPaths:@[idxPath] withRowAnimation:UITableViewRowAnimationFade];
                        }
                    }];
                });
                
            }
        });
    }
}


- (MainTableViewController*)getMainViewController
{
    UITabBarController* tabBarController = (UITabBarController*)privateWindow.rootViewController;
    
    if ([[tabBarController.viewControllers[0] topViewController]class] != [MainTableViewController class]) {
        return nil;
    }
    return (MainTableViewController*)[tabBarController.viewControllers[0] topViewController];
    /*
    if ([tabBarController.selectedViewController class] == [UINavigationController class]) {
        if ([[(UINavigationController*)tabBarController.selectedViewController topViewController] class] == [MainTableViewController class]) {
            return (MainTableViewController*)[(UINavigationController*)tabBarController.selectedViewController topViewController];
        }
    }
    return nil;
     */
}

@end
