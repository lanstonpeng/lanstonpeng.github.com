//
//  UIImage+Strech.m
//  OneThingWell
//
//  Created by Lanston Peng on 9/28/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "UIImage+Strech.h"

@implementation UIImage (Strech)

+ (UIImage *)stretchableImageWithLeftCapWidth:(NSInteger)leftCapWidth topCapHeight:(NSInteger)topCapHeight targetImage:(UIImage *)targetImage{
    
    UIEdgeInsets inset = UIEdgeInsetsMake(topCapHeight, leftCapWidth, targetImage.size.height - (topCapHeight + 1), targetImage.size.width - (leftCapWidth + 1));
    return [targetImage resizableImageWithCapInsets:inset];
}
@end
