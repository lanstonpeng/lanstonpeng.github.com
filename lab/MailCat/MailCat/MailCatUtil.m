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

- (void)displayToastMsg:(NSString*)msg inView:(UIView*)referenceView afterDelay:(NSTimeInterval)delay
{
    MBProgressHUD* toastMsg = [MBProgressHUD showHUDAddedTo:referenceView animated:YES];
    toastMsg.mode = MBProgressHUDModeText;
    toastMsg.labelText = msg;
    [toastMsg hide:YES afterDelay:delay];
}

- (void)displayToastMsg:(NSString*)msg inView:(UIView*)referenceView afterDelay:(NSTimeInterval)delay withCallback:(void (^)())callback
{
    MBProgressHUD* toastMsg = [MBProgressHUD showHUDAddedTo:referenceView animated:YES];
    toastMsg.mode = MBProgressHUDModeText;
    toastMsg.labelText = msg;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [toastMsg hide:YES];
        callback();
    });
}


- (void)showLoadingView:(UIView*)referenceView
{
    self.loadingView = [MBProgressHUD showHUDAddedTo:referenceView  animated:YES];
    self.loadingView.mode = MBProgressHUDModeIndeterminate;
}

- (void)hideLodingView{
    [self.loadingView hide:YES];
}

- (UIImage*)renderImage:(UIView*)view ofRect:(CGRect)frame
{
    UIGraphicsBeginImageContextWithOptions(frame.size,YES, 0);
    [view drawViewHierarchyInRect:frame afterScreenUpdates:YES];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (NSUInteger)calcuateLeftDays:(NSDate*)avaiableDate
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:[NSDate new]
                                                          toDate:avaiableDate
                                                         options:0];
    if ([components day] <= 0) {
        return 0;
    }
    return [components day];
}

- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}
@end
