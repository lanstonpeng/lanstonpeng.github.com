//
//  ViewController.m
//  ObjectTest
//
//  Created by Lanston Peng on 9/16/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLSessionDataDelegate>

@end

@implementation ViewController

- (void)viewDidLoad1 {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSInvocationOperation* op = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(download) object:nil];
    NSBlockOperation* blockOp = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"dudu 1");
    }];
    NSBlockOperation* blockOp2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"dudu 2");
    }];
    op.queuePriority = NSOperationQueuePriorityVeryLow;
    NSOperationQueue* queue = [[NSOperationQueue alloc]init];
    //[queue addOperation:op];
    blockOp2.queuePriority = NSOperationQueuePriorityVeryLow;
    blockOp.queuePriority = NSOperationQueuePriorityVeryHigh;
//    [queue addOperation:];
//    [queue addOperation:];
    
    [blockOp addDependency:blockOp2];
    //[queue addOperations:@[blockOp,blockOp2] waitUntilFinished:NO];
    
    dispatch_queue_t b = dispatch_queue_create("test",  DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t b2 = dispatch_queue_create("test2",  DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_group_t myGroup = dispatch_group_create();
    dispatch_group_async(myGroup, b, ^{
        NSLog(@"b is done");
    });
    dispatch_group_async(myGroup, b2, ^{
        NSLog(@"b2 is done");
    });
    
    dispatch_group_notify(myGroup, b, ^{
        NSLog(@"all queue's done");
    });
    
    int val = 10;
    const char* fmt = "val = %d\n";
    void (^blk)(void) = ^{
        printf(fmt,val);
    };
    val = 2;
    blk();
}

- (void)viewDidLoad
{
    int outside = 20;
    void (^blockObject)(void) = ^{
        NSLog(@"%d",outside);
    };
    blockObject();
}

- (void)download
{
    
    NSURLSessionConfiguration* configure = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:configure delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLRequest* request =[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://lanstonpeng.github.io"]];
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString* str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        //NSLog(@"%@",str);
        NSLog(@"done download");
    }];
    [task resume];
    
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    NSLog(@"receive");
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"error");
}


- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    NSLog(@"didReceiveResponse");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
