//
//  ViewController.m
//  ProjectBlackSwan
//
//  Created by Lanston Peng on 9/1/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "ViewController.h"
#import "TestCollection.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    dispatch_queue_t t1 = dispatch_queue_create("com.test.q1",  DISPATCH_QUEUE_CONCURRENT);
    
    __block TestCollection* tc = [TestCollection singleton];
    [tc addTestCollectionObj:@(1)];
    
    [tc getTestCollectionArr];
    dispatch_async(t1, ^{
        [tc addTestCollectionObj:@(1)];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [tc addTestCollectionObj:@(1)];
    });
    
    [tc getTestCollectionArr];
    
    __weak id o = [NSObject new];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
