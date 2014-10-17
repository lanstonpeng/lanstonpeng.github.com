//
//  LetterUser.m
//  MailCat
//
//  Created by Lanston Peng on 10/16/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "LetterUser.h"

@implementation LetterUser

+ (void)signUp:(NSString*)email withCallback:(void (^)(BOOL succeeded, NSError *error))callback{
    AVUser * user = [AVUser user];
    user.username = email;
    user.password = @"@mailcat@";
    user.email = email;
    [user setObject:@"" forKey:@"city"];
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        callback(succeeded,error);
    }];
    [[NSUserDefaults standardUserDefaults]setObject:email forKey:@"userEmail"];
}

+ (void)checkUserVerfied:(void (^)(BOOL isVerified))callback{
    NSString* email = [[NSUserDefaults standardUserDefaults] objectForKey:@"userEmail"];
    [AVUser logInWithUsernameInBackground:email password:@"@mailcat@" block:^(AVUser *user, NSError *error) {
        if (user != nil) {
            callback([[user objectForKey:@"emailVerified"]boolValue]);
        }
        else
        {
            callback(NO);
        }
    }];
}
@end
