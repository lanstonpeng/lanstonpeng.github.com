//
//  ViewController.m
//  ConnectionTester
//
//  Created by Lanston Peng on 6/5/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString* url = @"http://map.baidu.com/su?wd=ch&cid=131&type=1";
    UILabel* l = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 300)];
    //l.backgroundColor = [UIColor blackColor];
    l.textColor = [UIColor blackColor];
    l.backgroundColor= [UIColor orangeColor];
    l.numberOfLines = 00;
    [self.view addSubview:l];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"%@", json);
        NSArray* arr = (NSArray*)json[@"s"];
        for(int i =0 ;i <arr.count ;i++)
        {
            l.text = [NSString stringWithFormat:@"%@ %@",l.text?:@"",arr[i]];
            NSLog(@"%@",l.text);
        }
    }];
    [dataTask resume];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
