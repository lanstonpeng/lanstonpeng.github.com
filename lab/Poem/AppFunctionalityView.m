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
#import "UIImage+PoemResouces.h"


@interface AppFunctionalityView()<MFMailComposeViewControllerDelegate,UIAlertViewDelegate>

@property(strong,nonatomic)UIButton* recommendPoem;
@property(strong,nonatomic)UIButton* rateApp;
@property(strong,nonatomic)UIImageView* easterEggImageView;
@property(strong,nonatomic)UILabel* easterEggLabel;
@property(strong,nonatomic)ContainerViewController* sharedContainer;
@property(strong,nonatomic)UIButton* refreshButton;


@end
@implementation AppFunctionalityView

- (UILabel *)easterEggLabel
{
    if(!_easterEggLabel)
    {
        CGRect sFrame  = [UIScreen mainScreen].bounds;
        _easterEggLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, -180, sFrame.size.width, 80)];
        _easterEggLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Thin" size:13];
        _easterEggLabel.textColor = [UIColor whiteColor];
        _easterEggLabel.textAlignment = NSTextAlignmentRight;
        _easterEggLabel.numberOfLines = 0;
        _easterEggLabel.text = @"@lanstonpeng";
    }
    return _easterEggLabel;
}
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
        [_rateApp addTarget:self action:@selector(writeAppReview) forControlEvents:UIControlEventTouchUpInside];
        [self setUpButton:_rateApp];
        
        if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"hasClickFiveStar"] boolValue]) {
            _refreshButton = [[UIButton alloc]initWithFrame:CGRectMake(sFrame.size.width/3 * 2, 0, sFrame.size.width/3, 70)];
            UIImage* img =[UIImage imageNamed:@"refresh"];
            [_refreshButton setImage:img forState:UIControlStateNormal];
            [_refreshButton addTarget:self action:@selector(getBouncesPoem) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_refreshButton];
        }
        
        [_recommendPoem addTarget:self action:@selector(showMail) forControlEvents:UIControlEventTouchUpInside];
        _sharedContainer= [ContainerViewController sharedViewController];
        [self addSubview:_recommendPoem];
        [self addSubview:self.easterEggLabel];
        [self addSubview:_rateApp];
    }
    return self;
}

- (void)getBouncesPoem
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Get Extra Poem"
                                                      message:@"Give a 5 star to get extra poems"
                                                     delegate:nil
                                            cancelButtonTitle:@"Nope"
                                            otherButtonTitles:@"Sincerely Love to",nil];
    message.delegate = self;
    [message show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self writeAppReview];
        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"hasClickFiveStar"];
    }
}
- (void)writeAppReview
{
    NSString *str = @"itms-apps://itunes.com/apps/poemee";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
- (void)showMail
{
    NSString *emailTitle = @"[Poemee]Recommendation && Suggestion";
    // Email Content
    NSString *messageBody = @"hi,welcome:\n if you have any touching poems or suggestion to this app,please let me know,thanks";
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

#pragma mark mail delegate
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
