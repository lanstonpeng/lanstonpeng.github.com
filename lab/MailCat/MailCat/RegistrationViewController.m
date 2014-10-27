//
//  RegistrationViewController.m
//  MailCat
//
//  Created by Lanston Peng on 10/24/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "RegistrationViewController.h"
#import "MailCatUtil.h"
#import "LetterUser.h"
#import <AVOSCloud/AVOSCloud.h>

@interface RegistrationViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *resendButton;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;

@end

@implementation RegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_userStatus == UnRegister) {
    
    }
    else if(_userStatus == UnVerified)
    {
        
    }
}

- (BOOL)isFormValidated
{
    if (![[MailCatUtil singleton] validateEmail:self.emailTextField.text]) {
        self.msgLabel.text = @"请输入正确的邮件";
        [[MailCatUtil singleton]shakeView:self.emailTextField];
        return NO;
    }
    else if(self.pwdTextField.text.length < 1)
    {
        self.msgLabel.text = @"请输入密码";
        [[MailCatUtil singleton]shakeView:self.pwdTextField];
        return NO;
    }
    return YES;
}
- (IBAction)clikLogin:(id)sender {
    
    if ([self isFormValidated]) {
        [[MailCatUtil singleton]showLoadingView:self.view];
        [AVUser logInWithUsernameInBackground:self.emailTextField.text password:self.pwdTextField.text block:^(AVUser *user, NSError *error) {
            [[MailCatUtil singleton]hideLodingView];
            if (error) {
                [[MailCatUtil singleton] displayToastMsg:@"邮箱或者密码错误" inView:self.view];
                self.msgLabel.text = @"邮箱或者密码错误";
            }
            else
            {
                
                [[NSUserDefaults standardUserDefaults]setObject:user.password forKey:@"oops"];
                //no error ,login in success,start to load tableview
                [self dismissViewControllerAnimated:YES completion:^{
                    [self.delegate RegistrationViewControllerDidLogIn];
                }];
            }
            
        }];
    }
}
- (IBAction)clickRegsiter:(id)sender {
    if ([self isFormValidated]) {
        [[MailCatUtil singleton]showLoadingView:self.view];
        [LetterUser signUp:self.emailTextField.text pwd:self.pwdTextField.text withCallback:^(BOOL succeeded, NSError *error) {
            [[MailCatUtil singleton]hideLodingView];
            if (succeeded) {
                NSLog(@"sign up success");
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.msgLabel.text = @"注册成功,请到您的邮箱进行验证,准备返回";
                    //[self dismissViewControllerAnimated:YES completion:nil];
                });
            }
            else
            {
                NSLog(@"sign up faild %@",error);
                if ([[error.userInfo objectForKey:@"code"] integerValue] == 203) {
                    self.msgLabel.text = @"此电子邮箱已经被占用,请重新确认或者登陆,谢谢";
                    [[MailCatUtil singleton]shakeView:self.msgLabel];
                }
            }
        }];
    }
}

- (IBAction)clickResendEmailButton:(id)sender {
    [AVUser requestEmailVerify:[AVUser currentUser].email withBlock:^(BOOL succeeded, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (succeeded) {
                self.msgLabel.text = @"邮件重新发送成功,谢谢";
            }
            else
            {
                self.msgLabel.text = @"邮件重新发送失败,请稍后再试试哈";
            }
        });
    }];
}


- (IBAction)unwind:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
