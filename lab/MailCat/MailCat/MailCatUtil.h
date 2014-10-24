//
//  MailCatUtil.h
//  MailCat
//
//  Created by Lanston Peng on 10/20/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface MailCatUtil : NSObject

+ (instancetype)singleton;

- (void)displayToastMsg:(NSString*)msg inView:(UIView*)referenceView;
- (void)displayToastMsg:(NSString*)msg inView:(UIView*)referenceView afterDelay:(NSTimeInterval)delay;
- (void)displayToastMsg:(NSString*)msg inView:(UIView*)referenceView afterDelay:(NSTimeInterval)delay withCallback:(void (^)())callback;

- (void)showLoadingView:(UIView*)referenceView;

- (void)hideLodingView;

- (UIImage*)renderImage:(UIView*)view ofRect:(CGRect)frame;

- (NSUInteger)calcuateLeftDays:(NSDate*)avaiableDate;

- (BOOL) validateEmail: (NSString *) candidate;
@end
