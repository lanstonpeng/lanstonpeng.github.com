//
//  ViewController.m
//  ObjcCustomTransition
//
//  Created by Lanston Peng on 7/29/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "ViewController.h"
#import "ToViewController.h"

@interface ViewController ()

@property (strong,nonatomic)UIPercentDrivenInteractiveTransition* interactiveTransition;

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.tag = 1;
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    self.view.backgroundColor = [UIColor orangeColor];
    self.view.clipsToBounds = YES;
    [button setTitle:@"Click me" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    self.interactiveTransition = [UIPercentDrivenInteractiveTransition new];
    
    UIScreenEdgePanGestureRecognizer* edgePan = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    edgePan.edges = UIRectEdgeRight;
    [self.view addGestureRecognizer:edgePan];
}

- (void)handlePan:(UIScreenEdgePanGestureRecognizer*)recognizer
{
    CGFloat progress = [recognizer locationInView:self.view.superview].x / self.view.bounds.size.width * 1.0;
    
    progress = 1 - MAX(0, MIN(progress,1));
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:{
            ToViewController* toVC = [[ToViewController alloc]init];
            toVC.isByClick = NO;
            toVC.interactiveTransition = self.interactiveTransition;
            [self presentViewController:toVC animated:YES completion:nil];
            break;
        }
        case UIGestureRecognizerStateChanged:{
            [self.interactiveTransition updateInteractiveTransition:progress];
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        {
            if(progress > 0.5)
            {
                [self.interactiveTransition finishInteractiveTransition];
            }
            else
            {
                [self.interactiveTransition cancelInteractiveTransition];
            }
            break;
        }
            
        default:
            break;
    }
}

- (void)handleClick:(UIButton*)btn
{
    ToViewController* toVC = [[ToViewController alloc]init];
    toVC.isByClick = YES;
    
    [self presentViewController:toVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
