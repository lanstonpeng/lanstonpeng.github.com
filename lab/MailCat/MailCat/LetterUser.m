//
//  LetterUser.m
//  MailCat
//
//  Created by Lanston Peng on 10/16/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "LetterUser.h"

@implementation LetterUser

+ (void)signUp:(NSString*)email userName:(NSString*)userName pwd:(NSString*)password{
    AVUser * user = [AVUser user];
    user.username = userName;
    user.password = password;
    user.email = email;
    [user setObject:@"" forKey:@"city"];
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"sign up success");
        } else {
            NSLog(@"sign up failed %@",error);
        }
    }];
}
@end
