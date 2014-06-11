//
//  ContainerViewController.m
//  Poem
//
//  Created by Lanston Peng on 5/30/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "ContainerViewController.h"
#import "IntroductionViewController.h"
#import "MainPageViewController.h"
#import "CollectionViewController.h"

@interface ContainerViewController ()

@property (strong,nonatomic)NSMutableArray* stack;
@property (strong,nonatomic)UIViewController* currentViewController;

@end

@implementation ContainerViewController

+ (instancetype)sharedViewController
{
    static ContainerViewController* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [ContainerViewController new];
    });
    return instance;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //MainPageViewController* mainVC = [MainPageViewController new];
    //IntroductionViewController* introductionVC = [IntroductionViewController new];
    CollectionViewController* mainPage = [CollectionViewController new];
    _currentViewController = mainPage;
    _stack = [[NSMutableArray alloc]init];
    mainPage.view.frame = self.view.bounds;
    [self addChildViewController:mainPage];
    [self.view addSubview:mainPage.view];
    [_currentViewController didMoveToParentViewController:self];
    [_stack addObject:_currentViewController];
}

- (void)pushViewController:(UIViewController *)enqueViewController
{
    [_stack addObject:enqueViewController];
    [enqueViewController.view layoutIfNeeded];
    [enqueViewController willMoveToParentViewController:self];
    
    CGRect inputViewFrame = self.view.bounds;
    CGFloat inputViewHeight=inputViewFrame.size.height;
    
    CGRect newFrame=CGRectMake( 0,self.view.bounds.size.height, inputViewFrame.size.width, inputViewFrame.size.height);
   
    enqueViewController.view.frame = newFrame;
    
    [self addChildViewController:enqueViewController];
    [self.view addSubview:enqueViewController.view];
    
    CGRect offSetRect=CGRectOffset(newFrame, 0, -inputViewHeight);
    CGRect otherOffsetRect=CGRectOffset(self.currentViewController.view.frame,0, -inputViewHeight);
    
    [UIView animateWithDuration:0.6 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        enqueViewController.view.frame = offSetRect;
        _currentViewController.view.frame = otherOffsetRect;
    } completion:^(BOOL finished) {
        [_currentViewController.view removeFromSuperview];
        [_currentViewController removeFromParentViewController];
        _currentViewController = enqueViewController;
        [enqueViewController didMoveToParentViewController:self];
    }];
}
- (void)popViewController
{
    int len = (int)[_stack count];
    if (len > 1){
        UIViewController* popViewController = _stack[len - 2];
        [popViewController willMoveToParentViewController:self];
        
        [popViewController.view layoutIfNeeded];
        CGRect inputViewFrame=self.view.bounds;
        CGFloat inputViewWidth=inputViewFrame.size.width;
        
        CGRect newFrame=CGRectMake(-self.view.bounds.size.width, 0, inputViewFrame.size.width, inputViewFrame.size.height);
       
        //popViewController.view.frame = newFrame;
        
        [self addChildViewController:popViewController];
        [self.view addSubview:popViewController.view];
        
        CGRect offSetRect=CGRectOffset(self.currentViewController.view.frame, inputViewWidth, 0.0f);
        CGRect otherOffsetRect=CGRectOffset(newFrame, inputViewWidth, 0.0f);
        
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            _currentViewController.view.frame = offSetRect;
            
            popViewController.view.frame = otherOffsetRect;
        } completion:^(BOOL finished) {
            [_currentViewController removeFromParentViewController];
            [_currentViewController.view removeFromSuperview];
            _currentViewController = popViewController;
            [_stack removeLastObject];
            [popViewController didMoveToParentViewController:self];
        }];
    }
    else{
        return;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
