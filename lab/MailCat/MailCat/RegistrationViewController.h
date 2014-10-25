//
//  RegistrationViewController.h
//  MailCat
//
//  Created by Lanston Peng on 10/24/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "MailCatBaseViewController.h"

typedef enum
{
    UnRegister = 1,
    UnVerified
}UserStatus;

@protocol RegistrationViewControllerDelegate <NSObject>

- (void)RegistrationViewControllerDidLogIn;

@end

@interface RegistrationViewController : MailCatBaseViewController

@property (nonatomic)UserStatus userStatus;

@property (weak,nonatomic)id<RegistrationViewControllerDelegate> delegate;

@end
