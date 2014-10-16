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
@property (strong, nonatomic) UIImageView *paperImageView;

@property (weak, nonatomic) IBOutlet UIImageView *folderImageView;

@property (strong,nonatomic)UIAttachmentBehavior* attachmentBehavior;

@property (strong,nonatomic)UIDynamicAnimator* animator;
@property (weak, nonatomic) IBOutlet UIButton *prepareWritingBtn;

@end


@implementation EntranceViewController
{
    CGFloat startPanY;
    CGRect paperImageViewOriginalFrame;
}
- (IBAction)showSideMenu:(id)sender {
    
}

- (void)initUI
{
    self.prepareWritingBtn.layer.cornerRadius = 3;
    
    self.paperImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"paper"]];
    self.paperImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view insertSubview:self.paperImageView belowSubview:self.folderImageView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactiveTransition = [UIPercentDrivenInteractiveTransition new];
    
    [self initUI];
    
    self.animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    CGRect folderFrame = self.folderImageView.frame;
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    paperImageViewOriginalFrame = CGRectMake(screenBounds.size.width * 0.1,
                                             folderFrame.origin.y - screenBounds.size.height * 0.01,
                                             screenBounds.size.width * 0.8,
                                             screenBounds.size.height * 0.2);
    _paperImageView.frame = paperImageViewOriginalFrame;
}

- (IBAction)handlePanUpGesture:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint paperLocation = [recognizer locationInView:self.paperImageView];
    CGPoint viewLocation  = [recognizer locationInView:self.view];
    self.attachmentBehavior.anchorPoint = [recognizer locationInView:self.view];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        //UIDynamic
        [self.animator removeAllBehaviors];
       
        UIOffset centerOffset = UIOffsetMake(paperLocation.x - CGRectGetMidX(self.paperImageView.bounds), paperLocation.y - CGRectGetMidY(self.paperImageView.bounds));
        
        self.attachmentBehavior = [[UIAttachmentBehavior alloc]initWithItem:self.paperImageView offsetFromCenter:centerOffset attachedToAnchor:viewLocation];
        [self.animator addBehavior:self.attachmentBehavior];
    }
    else if(recognizer.state == UIGestureRecognizerStateChanged)
    {
        self.attachmentBehavior.anchorPoint = viewLocation;
    }
    else if(recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled)
    {
        [self.animator removeAllBehaviors];
        CGPoint point = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(paperImageViewOriginalFrame));
        UISnapBehavior* snapBehavior = [[UISnapBehavior alloc]initWithItem:self.paperImageView snapToPoint:point];
        [self.animator addBehavior:snapBehavior];
    }
    
    //CGFloat progress  =[recognizer locationInView:self.view.superview].y /self.view.superview.bounds.size.height;
    
    /*
    CGFloat progress;
    if(recognizer.state == UIGestureRecognizerStateBegan)
    {
        startPanY = [recognizer locationInView:self.view.superview].y;
        CGFloat currentY = [recognizer locationInView:self.view.superview].y;
        progress = ( currentY - startPanY ) / (self.view.superview.bounds.size.height * 0.2);
        
        NSLog(@"currentY: %f",currentY);
        NSLog(@"progress: %f",progress);
        if (progress >=  0) {
            return;
        }
        
        progress = 1.0 - MIN(1.0,MAX(0 , progress));
        
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
    */

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
