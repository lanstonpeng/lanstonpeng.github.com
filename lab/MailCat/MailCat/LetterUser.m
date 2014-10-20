//
//  LetterUser.m
//  MailCat
//
//  Created by Lanston Peng on 10/16/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "LetterUser.h"


@implementation LetterUser


+ (void)signUp:(NSString*)email pwd:(NSString*)pwd withCallback:(void (^)(BOOL succeeded, NSError *error))callback{
    AVUser * user = [AVUser user];
    user.username = email;
    user.password = pwd;
    user.email = email;
    [user setObject:@"" forKey:@"city"];
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        callback(succeeded,error);
    }];
    [[NSUserDefaults standardUserDefaults]setObject:user.password forKey:@"oops"];
}

+ (void)checkUserVerfied:(void (^)(BOOL isVerified))callback{
    AVUser * currentUser = [AVUser currentUser];
    
    NSString* pwd = [[NSUserDefaults standardUserDefaults]objectForKey:@"oops"];
    [AVUser logInWithUsernameInBackground:currentUser.email password:pwd  block:^(AVUser *user, NSError *error) {
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
