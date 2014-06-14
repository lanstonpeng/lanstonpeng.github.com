//
//  UIImage+PoemResouces.m
//  Poem
//
//  Created by Lanston Peng on 5/31/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "UIImage+PoemResouces.h"

@implementation UIImage (PoemResouces)

- (id)initWithName:(NSString *)name
{
    
    return [self initWithName:name withExtension:@"png"];
}
- (id)initWithName:(NSString *)name withExtension:(NSString*)extension
{
    NSString *resoucesPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"poem.bundle"];
    NSString* path = [[NSBundle bundleWithPath:resoucesPath]pathForResource:name ofType:extension];
    return [self initWithData:[NSData dataWithContentsOfFile:path]];
}
@end
