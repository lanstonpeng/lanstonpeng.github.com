//
//  Util.h
//  LineSum
//
//  Created by Lanston Peng on 4/17/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceInfo.h"
@interface Util : NSObject

+ (NSDictionary*)generateNumbers:(NSUInteger)count;
+ (UIColor*)generateColor;
+ (UIColor*)generateColorWithNum:(NSString*)valString;
@end
