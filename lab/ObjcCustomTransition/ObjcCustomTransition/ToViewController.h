//
//  ToViewController.h
//  ObjcCustomTransition
//
//  Created by Lanston Peng on 7/29/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToViewController : UIViewController

@property (nonatomic)BOOL isByClick;

@property (strong,nonatomic)UIPercentDrivenInteractiveTransition* interactiveTransition;

@end
