//
//  ViewController.m
//  LScrollView
//
//  Created by Lanston Peng on 4/26/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "ViewController.h"
#import "LScrollView.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *indicator;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@end

@implementation ViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    LScrollView* lScrollView = [[LScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 300)];
    lScrollView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:lScrollView];
    UILabel* l = [[UILabel alloc]initWithFrame:CGRectMake(50, 50, 100, 100)];
    l.text = @"Label";
    l.layer.borderColor = [UIColor blackColor].CGColor;
    l.textAlignment = NSTextAlignmentCenter;
    l.backgroundColor = [UIColor purpleColor];
    [lScrollView addSubview:l];
    
    /*
    UILabel* l2 = [[UILabel alloc]initWithFrame:CGRectMake(100, 160, 100, 100)];
    l2.text = @"Label";
    l2.layer.borderColor = [UIColor blackColor].CGColor;
    l2.textAlignment = NSTextAlignmentCenter;
    l2.backgroundColor = [UIColor purpleColor];
    [lScrollView addSubview:l2];
     */
    /*
    //self.datePicker.frame = CGRectMake(0, -self.datePicker.frame.size.height, self.datePicker.frame.size.width, self.datePicker.frame.size.height);
    self.scrollView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
    self.scrollView.contentSize = CGSizeMake(320, self.scrollView.frame.size.height + 200);
    self.scrollView.bounces = YES;
    self.indicator.backgroundColor = [UIColor orangeColor];
    [self.indicator removeConstraints:self.indicator.constraints];
    self.indicator.frame = CGRectMake(0, 0, 320, 600);
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
