//
//  MailCatUtil.h
//  MailCat
//
//  Created by Lanston Peng on 10/20/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface MailCatUtil : NSObject

+ (instancetype)singleton;

- (void)displayToastMsg:(NSString*)msg inView:(UIView*)referenceView;

- (void)showLoadingView:(UIView*)referenceView;

- (void)hideLodingView;

- (UIImage*)renderImage:(UIView*)view ofRect:(CGRect)frame;

- (NSUInteger)calcuateLeftDays:(NSDate*)avaiableDate;
@end
