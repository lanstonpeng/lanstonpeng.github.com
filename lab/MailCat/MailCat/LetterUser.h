//
//  LetterUser.h
//  MailCat
//
//  Created by Lanston Peng on 10/16/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>

@interface LetterUser : NSObject

+ (void)signUp:(NSString*)email userName:(NSString*)userName pwd:(NSString*)password;

@end
