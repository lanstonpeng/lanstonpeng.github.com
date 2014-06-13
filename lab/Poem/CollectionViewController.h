//
//  CollectionViewController.h
//  Poem
//
//  Created by Lanston Peng on 6/2/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CollectionViewLoadingDelegate <NSObject>
- (void)collectionViewWillAppear;
@end

@interface CollectionViewController : UIViewController

    @property (strong,nonatomic)id<CollectionViewLoadingDelegate>delegate;

@end

