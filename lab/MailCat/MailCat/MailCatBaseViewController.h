//
//  MailCatBaseViewController.h
//  MailCat
//
//  Created by Lanston Peng on 10/20/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MailCatBaseViewController : UIViewController

@property (strong,nonatomic)UIPercentDrivenInteractiveTransition* interactiveTransition;

@property (strong,nonatomic)NSString* storyBoardIdentifier;

@property (nonatomic)BOOL isByClick;

@property (nonatomic)UIRectEdge panDirection;
@end
