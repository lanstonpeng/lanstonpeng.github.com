//
//  CollectionViewScrollDelegate.h
//  Poem
//
//  Created by Lanston Peng on 6/8/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol CollectionViewScrollDelegate <NSObject>

- (void)CollectionViewScrollViewDidScroll:(UIScrollView*)scrollView;
- (void)CollectionViewScrollViewDidBeganScroll:(UIScrollView*)scrollView;
- (void)CollectionViewScrollViewDidEndScroll:(UIScrollView*)scrollView;
@end
