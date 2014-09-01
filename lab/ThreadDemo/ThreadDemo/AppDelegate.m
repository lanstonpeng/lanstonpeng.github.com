//
//  AppDelegate.m
//  ThreadDemo
//
//  Created by Lanston Peng on 8/29/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
{
    int tickets;
    int count;
    NSThread* threadOne;
    NSThread* threadSec;
    NSCondition* ticketCondition;
    NSLock* ticketLock;
}
            

- (void)runSomething
{
    while (1) {
        //[ticketLock lock];
        //[ticketCondition lock];
        
//        @synchronized(@(tickets))
//        {
            if (tickets >= 0)
            {
                [NSThread sleepForTimeInterval:0.02];
                count = 100 - tickets;
                NSLog(@"当前票数是:%d,售出:%d,线程名:%@",tickets,count,[[NSThread currentThread] name]);
                tickets--;
            }
            else
            {
                break;
            }
        //}
        //[ticketLock unlock];
        //[ticketCondition unlock];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    tickets = 100;
    count = 0;
    ticketLock = [[NSLock alloc]init];
    ticketCondition = [[NSCondition alloc]init];
    
    threadOne = [[NSThread alloc]initWithTarget:self selector:@selector(runSomething) object:nil];
    threadOne.name = @"one";
    threadSec = [[NSThread alloc]initWithTarget:self selector:@selector(runSomething) object:nil];
    threadSec.name = @"second";
    
//    [threadOne start];
//    [threadSec start];
    
    NSOperationQueue* queue = [[NSOperationQueue alloc]init];
    
    
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
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
