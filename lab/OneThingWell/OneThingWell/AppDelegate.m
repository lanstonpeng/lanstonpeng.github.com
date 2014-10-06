//  AppDelegate.m
//  OneThingWell
//
//  Created by Lanston Peng on 9/24/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "AppDelegate.h"
#import "RSSFetcher.h"
#import "AppDataManipulator.h"
#import <AVOSCloud/AVOSCloud.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kLimitNumber  @10
#define kThumblrURL @"onethingwell.tumblr.com"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //((UINavigationController*)self.window.rootViewController).navigationBar.topItem.title = @"One Thing Well";
    //[[UITabBar appearance] setBarTintColor:[UIColor orangeColor]];
    [[UITabBar appearance] setTintColor:UIColorFromRGB(0x6200FF)];
    [[UINavigationBar appearance]setTintColor:UIColorFromRGB(0x6200FF)];
    //[[UINavigationBar appearance]setBarTintColor:UIColorFromRGB(0x1A1331)];
    RSSFetcher* fetcher = [RSSFetcher singleton];
    fetcher.window = self.window;
    [fetcher fetchNextPosts];
    
    [AVOSCloud setApplicationId:@"ax5s838wknvwpsloon0cct1z01sjnxkm8hpqcxwarusfnaje"
                      clientKey:@"x0b1v2bqxm9qp6829t24h56w83o7nqjda268zrqksheatzke"];
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    /*
    AVObject *testObject = [AVObject objectWithClassName:@"TestObject"];
    [testObject setObject:@"bar" forKey:@"foo"];
    [testObject incrementKey:@"score"];
    [testObject saveEventually:^(BOOL succeeded, NSError *error) {
        NSLog(succeeded?@"hulala":@"oops");
    }];
     */
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[AppDataManipulator singleton]flushDataToFile];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[AppDataManipulator singleton]flushDataToFile];
}


@end
