//
//  EntranceViewController.m
//  MailCat
//
//  Created by Lanston Peng on 10/12/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "EntranceViewController.h"
#import "TransitionManager.h"
#import "WritingViewController.h"

@interface EntranceViewController ()


@property (strong,nonatomic)UIPercentDrivenInteractiveTransition* interactiveTransition;
@property (weak, nonatomic) IBOutlet UIImageView *paperImageView;
@property (weak, nonatomic) IBOutlet UIImageView *folderImageView;

@end

@implementation EntranceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactiveTransition = [UIPercentDrivenInteractiveTransition new];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    CGRect folderFrame = self.folderImageView.frame;
    CGRect papaerFrame = self.paperImageView.frame;
    _paperImageView.frame = CGRectMake(_paperImageView.frame.origin.x, folderFrame.origin.y - 50, papaerFrame.size.width, papaerFrame.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)handlePanUpGesture:(UIPanGestureRecognizer *)recognizer {
    CGFloat progress  =[recognizer locationInView:self.view.superview].y /self.view.superview.bounds.size.height;
    
    progress = 1.0 - MIN(1.0,MAX(0 , progress));
    NSLog(@"%f",progress);
    
    if(recognizer.state == UIGestureRecognizerStateBegan)
    {
        WritingViewController * writingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Writing"];
        writingViewController.interactiveTransition = self.interactiveTransition;
        [self presentViewController:writingViewController animated:YES completion:nil];
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        [self.interactiveTransition updateInteractiveTransition:progress];
        self.paperImageView.frame = CGRectOffset(self.paperImageView.frame, 0, -progress * 10);
    }
    else if(recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled)
    {
        if (progress > 0.5) {
            [self.interactiveTransition finishInteractiveTransition];
        }
        else
        {
            [self.interactiveTransition cancelInteractiveTransition];
        }
        self.interactiveTransition = nil;
    }

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
