//
//  UIImage+Strech.h
//  OneThingWell
//
//  Created by Lanston Peng on 9/28/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Strech)

+ (UIImage *)stretchableImageWithLeftCapWidth:(NSInteger)leftCapWidth topCapHeight:(NSInteger)topCapHeight targetImage:(UIImage *)targetImage;

@end
