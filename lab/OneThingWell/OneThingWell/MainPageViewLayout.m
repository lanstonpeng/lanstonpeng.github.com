//
//  MainPageViewLayout.m
//  OneThingWell
//
//  Created by Lanston Peng on 9/29/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "MainPageViewLayout.h"

@implementation MainPageViewLayout

- (void)prepareLayout
{
    CGRect sFrame = [UIScreen mainScreen].bounds;
    self.itemSize = CGSizeMake(sFrame.size.width - 20, 0.3 * sFrame.size.height);
}


@end
