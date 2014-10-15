//
//  PreviewLetterViewController.m
//  MailCat
//
//  Created by Lanston Peng on 10/15/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "PreviewLetterViewController.h"
#import <AVOSCloud/AVOSCloud.h>

@interface PreviewLetterViewController ()

@end

@implementation PreviewLetterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendLetterData
{
    AVObject *appAVObject = [AVObject objectWithClassName:@"LetterData"];
    [appAVObject setObject:self.letterModel.senderCity forKey:@"senderCity"];
    [appAVObject setObject:self.letterModel.sendToEmail forKey:@"sendToEmail"];
    [appAVObject setObject:self.letterModel.receiverCity forKey:@"receiverCity"];
    [appAVObject setObject:self.letterModel.receiverName forKey:@"receiverName"];
    [appAVObject setObject:self.letterModel.letterBody forKey:@"letterBody"];
    [appAVObject saveEventually:^(BOOL succeeded, NSError *error) {
        NSLog(@"%@",error);
    }];
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
