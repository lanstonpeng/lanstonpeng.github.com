//
//  NSString+upperCase.m
//  ObjectTest
//
//  Created by Lanston Peng on 9/23/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "NSString+upperCase.h"
#import <objc/runtime.h>

@implementation NSString (upperCase)

+ (void)load
{
    NSLog(@"loaded");
}

- (NSString*)upperMySelf{
    return self.uppercaseString;
}

- (NSString *)sucker
{
    return @"sucker hula";
}

- (void)setSucker:(NSString *)sucker
{
}


@end
