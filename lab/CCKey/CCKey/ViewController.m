//
//  ViewController.m
//  CCKey
//
//  Created by Lanston Peng on 6/16/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
            

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UITextView* tf = [[UITextView alloc]initWithFrame:CGRectMake(0,0,320,200)];
    
    tf.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:tf];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}   

@end
