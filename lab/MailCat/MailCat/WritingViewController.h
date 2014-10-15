//
//  WritingViewController.h
//  MailCat
//
//  Created by Lanston Peng on 10/12/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LetterModel.h"

@interface WritingViewController : UIViewController

@property (strong,nonatomic)UIPercentDrivenInteractiveTransition* interactiveTransition;

@property (strong,nonatomic)LetterModel* letterModel;

@end
