//
//  CollectionViewController.h
//  Poem
//
//  Created by Lanston Peng on 6/2/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@protocol CollectionViewLoadingDelegate <NSObject>
- (void)collectionViewWillAppear;
@end

@interface CollectionViewController : GAITrackedViewController

    @property (strong,nonatomic)id<CollectionViewLoadingDelegate>delegate;

@end

