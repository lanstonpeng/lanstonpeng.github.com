//
//  AppFunctionalityView.m
//  Poem
//
//  Created by Lanston Peng on 6/14/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "AppFunctionalityView.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "ContainerViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface AppFunctionalityView()<MFMailComposeViewControllerDelegate>

@property(strong,nonatomic)UIButton* recommendPoem;
@property(strong,nonatomic)UIButton* rateApp;
@property(strong,nonatomic)ContainerViewController* sharedContainer;
@end
@implementation AppFunctionalityView

- (void)setUpButton:(UIButton*)btn
{
    btn.titleLabel.font = [UIFont fontWithName:@"icomoon" size:25];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.titleLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
    btn.titleLabel.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    btn.titleLabel.layer.shadowRadius = 3.0;
    btn.titleLabel.layer.shadowOpacity = 0.9;
    btn.titleLabel.layer.masksToBounds = NO;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGRect sFrame  = [UIScreen mainScreen].bounds;
        _recommendPoem = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, sFrame.size.width/3, 70)];
        [_recommendPoem setTitle:@"m" forState:UIControlStateNormal];
        [self setUpButton:_recommendPoem];
    
        _rateApp = [[UIButton alloc]initWithFrame:CGRectMake(sFrame.size.width/3, 0, sFrame.size.width/3, 70)];
        [_rateApp setTitle:@"h" forState:UIControlStateNormal];
        [self setUpButton:_rateApp];
        //http://stackoverflow.com/questions/18905686/itunes-review-url-and-ios-7-ask-user-to-rate-our-app-appstore-show-a-blank-pag
        
        //_recommendPoem.backgroundColor = [UIColor orangeColor];
        [_recommendPoem addTarget:self action:@selector(showMail) forControlEvents:UIControlEventTouchUpInside];
        _sharedContainer= [ContainerViewController sharedViewController];
        [self addSubview:_recommendPoem];
        [self addSubview:_rateApp];
    }
    return self;
}

- (void)showMail
{
    NSString *emailTitle = @"[Poemee]Poem Recommendation";
    // Email Content
    NSString *messageBody = @"Title:\n\n Why it motivates you:\n\n ";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"lanstonpeng@gmail.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [_sharedContainer presentViewController:mc animated:YES completion:NULL];
}
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self.delegate MailDidDismiss];
    [_sharedContainer dismissViewControllerAnimated:YES completion:NULL];
}

@end
