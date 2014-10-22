//
//  LetterStatusViewController.m
//  MailCat
//
//  Created by Lanston Peng on 10/16/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "LetterStatusViewController.h"
#import "MailCatUtil.h"

@interface LetterStatusViewController ()
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendingLabel;
@property (weak, nonatomic) IBOutlet UILabel *sentLabel;
@property (weak, nonatomic) IBOutlet UILabel *readLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@end

@implementation LetterStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.emailLabel.text = self.letterModel.sendToEmail;
    self.doneButton.layer.cornerRadius = 3;
    switch (self.letterModel.letterStatus) {
        case Pending:
            self.sendingLabel.textColor = UIColorFromRGB(0xF5A623);
            break;
        case Sent:
            self.sentLabel.textColor = UIColorFromRGB(0xF5A623);
            break;
        case Received:
            self.readLabel.textColor = UIColorFromRGB(0xF5A623);
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)dismissVC:(id)sender {
    UIViewController* topVC = [self presentingViewController];
    while ([topVC presentingViewController]) {
        topVC = [topVC presentingViewController];
    }
    [topVC dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
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
