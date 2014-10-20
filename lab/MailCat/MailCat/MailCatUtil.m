//
//  MailCatUtil.m
//  MailCat
//
//  Created by Lanston Peng on 10/20/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "MailCatUtil.h"

@interface MailCatUtil()

@property (strong,nonatomic)MBProgressHUD* loadingView;

@end

@implementation MailCatUtil

+ (instancetype)singleton
{
    static dispatch_once_t onceToken;
    static MailCatUtil* instance;
    dispatch_once(&onceToken, ^{
        instance = [MailCatUtil new];
    });
    return instance;
}
- (void)displayToastMsg:(NSString*)msg inView:(UIView*)referenceView
{
    MBProgressHUD* toastMsg = [MBProgressHUD showHUDAddedTo:referenceView animated:YES];
    toastMsg.mode = MBProgressHUDModeText;
    toastMsg.labelText = msg;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [toastMsg hide:YES];
    });
}

- (void)showLoadingView:(UIView*)referenceView
{
    self.loadingView = [MBProgressHUD showHUDAddedTo:referenceView  animated:YES];
    self.loadingView.mode = MBProgressHUDModeDeterminate;
}

- (void)hideLodingView{
    [self.loadingView hide:YES];
}
@end
