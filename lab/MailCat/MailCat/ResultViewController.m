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

@interface ResultViewController ()<NSLayoutManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *letterTextView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@end

@implementation ResultViewController

- (IBAction)sendLetter:(id)sender {
    AVObject *appAVObject = [AVObject objectWithClassName:@"LetterData"];
    [appAVObject setObject:self.letterModel.senderCity forKey:@"senderCity"];
    [appAVObject setObject:self.letterModel.sendToEmail forKey:@"sendToEmail"];
    [appAVObject setObject:self.letterModel.receiverCity forKey:@"receiverCity"];
    [appAVObject setObject:self.letterModel.receiverName forKey:@"receiverName"];
    [appAVObject setObject:self.letterModel.letterBody forKey:@"letterBody"];
    [appAVObject setObject:self.letterModel.sendDate forKey:@"sendDate"];
    [appAVObject setObject:@(self.letterModel.letterStatus) forKey:@"letterStatus"];
    
    MBProgressHUD* toastMsg = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    toastMsg.mode = MBProgressHUDModeIndeterminate;
    [appAVObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [toastMsg hide:YES];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    LetterStatusViewController* statusVC = (LetterStatusViewController*)segue.destinationViewController;
    //memory leak if you dont copy one
    statusVC.letterModel = [self.letterModel copy];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sendButton.layer.cornerRadius = 3;
    self.letterTextView.layoutManager.delegate = self;
    NSString* text = [NSString stringWithFormat:@"%@\n    %@",self.letterModel.receiverName,self.letterModel.letterBody];
    self.letterTextView.text = text;
    self.letterModel.sendDate = [NSDate new];
}

- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager lineSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect
{
    return 7;
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
