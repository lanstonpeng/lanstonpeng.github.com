//
//  Util.h
//  LineSum
//
//  Created by Lanston Peng on 4/17/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceInfo.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface Util : NSObject

+ (NSDictionary*)generateNumbers:(NSUInteger)count;
+ (UIColor*)generateColor;
+ (UIColor*)generateColorWithNum:(NSString*)valString;
@end
