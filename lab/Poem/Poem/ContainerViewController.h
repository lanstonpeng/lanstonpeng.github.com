//
//  ContainerViewController.h
//  Poem
//
//  Created by Lanston Peng on 5/30/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContainerViewController : UIViewController

+ (instancetype)sharedViewController;
-(void)pushViewController:(UIViewController*)enqueViewController;
-(void)popViewController;
@end
