//
//  ResultViewController.m
//  MailCat
//
//  Created by Lanston Peng on 10/15/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "ResultViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "LetterStatusViewController.h"
#import "MBProgressHUD.h"
#import "MailCatUtil.h"

//TODO:delete MBrogressHD code

@interface ResultViewController ()<NSLayoutManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *letterTextView;

@property (strong,nonatomic)UIAttachmentBehavior* attachmentBehavior;
@property (strong,nonatomic)UIDynamicAnimator* animator;
@property (weak, nonatomic) IBOutlet UIView *letterContainerView;

@end

@implementation ResultViewController
{
    CGRect paperImageViewOriginalFrame;
}

- (void)sendEmailToUser:(NSString*)sendToEmail
{
    //check if the sendToEmail is registered
    AVQuery* query = [AVQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" equalTo:sendToEmail];
    [AVCloud setProductionMode:NO];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects.count < 1) {
            //run cloud code to send real email
            NSDictionary* parameters =  @{
                                          @"sendToMail":sendToEmail,
                                          @"body":self.letterModel.letterBody,
                                          @"senderMail":self.letterModel.senderEmail?:@"",
                                          @"dayLeft":@([[MailCatUtil singleton]calcuateLeftDays:self.letterModel.receiveDate]),
                                          @"receiverName":self.letterModel.receiverName
                                          };
            [AVCloud callFunctionInBackground:@"sendPreviewMail" withParameters: parameters block:^(id object, NSError *error) {
                //TODO:error handler
                NSLog(@"send mail result:%@",object);
                if (error) {
                    NSLog(@"send mail error:%@",error);
                }
                
            }];
        }
    }];
    
    
}
- (IBAction)sendLetter:(id)sender {
    self.letterModel.letterStatus = Pending;
    AVObject *appAVObject = [AVObject objectWithClassName:@"LetterData"];
    [appAVObject setObject:self.letterModel.senderCity forKey:@"senderCity"];
    [appAVObject setObject:self.letterModel.sendToEmail forKey:@"sendToEmail"];
    [appAVObject setObject:self.letterModel.senderEmail forKey:@"senderEmail"];
    [appAVObject setObject:self.letterModel.receiverCity forKey:@"receiverCity"];
    [appAVObject setObject:self.letterModel.receiverName forKey:@"receiverName"];
    [appAVObject setObject:self.letterModel.letterBody forKey:@"letterBody"];
    [appAVObject setObject:self.letterModel.receiveDate forKey:@"receiveDate"];
    [appAVObject setObject:self.letterModel.sendDate forKey:@"sendDate"];
    [appAVObject setObject:@(self.letterModel.letterStatus) forKey:@"letterStatus"];
    
    MBProgressHUD* toastMsg = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    toastMsg.mode = MBProgressHUDModeIndeterminate;
    [appAVObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [toastMsg hide:YES];
        [self sendEmailToUser:self.letterModel.sendToEmail];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    LetterStatusViewController* statusVC = (LetterStatusViewController*)segue.destinationViewController;
    //memory leak if you dont copy one
    self.letterModel.letterStatus = Pending;
    statusVC.letterModel = [self.letterModel copy];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sendButton.layer.cornerRadius = 3;
    self.storyBoardIdentifier = @"resultViewController";
    self.letterTextView.layoutManager.delegate = self;
    NSString* text = [NSString stringWithFormat:@"%@\n    %@",self.letterModel.receiverName,self.letterModel.letterBody];
    self.letterTextView.text = text;
    self.panDirection = UIRectEdgeLeft;
    self.animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
}

- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager lineSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect
{
    return 7;
}

- (IBAction)handlePanUpGesture:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint paperLocation = [recognizer locationInView:self.letterContainerView];
    CGPoint viewLocation  = [recognizer locationInView:self.view];
    self.attachmentBehavior.anchorPoint = [recognizer locationInView:self.view];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        //UIDynamic
        [self.animator removeAllBehaviors];
        
        UIOffset centerOffset = UIOffsetMake(paperLocation.x - CGRectGetMidX(self.letterContainerView.bounds), paperLocation.y - CGRectGetMidY(self.letterContainerView.bounds));
        
        self.attachmentBehavior = [[UIAttachmentBehavior alloc]initWithItem:self.letterContainerView offsetFromCenter:centerOffset attachedToAnchor:viewLocation];
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
        UISnapBehavior* snapBehavior = [[UISnapBehavior alloc]initWithItem:self.letterContainerView snapToPoint:point];
        [self.animator addBehavior:snapBehavior];
    }
    
}
- (void)viewDidLayoutSubviews
{
    paperImageViewOriginalFrame = self.letterContainerView.frame;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)unwindSegue:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
