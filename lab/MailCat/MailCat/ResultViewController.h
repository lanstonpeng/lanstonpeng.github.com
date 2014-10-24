//
//  ResultViewController.h
//  MailCat
//
//  Created by Lanston Peng on 10/15/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LetterModel.h"
#import "MailCatBaseViewController.h"

@interface ResultViewController : MailCatBaseViewController

@property(strong,nonatomic)LetterModel* letterModel;

@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@end
