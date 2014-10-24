//
//  InboxViewController.m
//  MailCat
//
//  Created by Lanston Peng on 10/17/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "InboxViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "MailTableViewCell.h"
#import "LetterUser.h"
#import "MailCatUtil.h"
#import "LetterStatusViewController.h"
#import "ResultViewController.h"
#import "LetterModel.h"

typedef enum
{
    UnRegister = 1,
    HasVerified,
    UnVerified
}UserStatus;

@interface InboxViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *setMailButton;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) IBOutlet UIButton *resendEmailButton;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UITextField *mailTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic)NSArray* mailDataArr;

@property (strong,nonatomic)NSMutableArray* sendMailDataArr;

@property (strong,nonatomic)NSMutableArray* receiveMailDataArr;

@end

@implementation InboxViewController
{
    BOOL isButtonClicked;
    UserStatus userStatus;
}

- (void)checkEmailVerified
{
    [LetterUser checkUserVerfied:^(BOOL isVerified) {
        dispatch_async(dispatch_get_main_queue(),^{
            if (isVerified) {
                self.setMailButton.hidden = YES;
                self.tableView.hidden = NO;
                [self startLoadingTableView];
            }
            else
            {
                self.descriptionLabel.text = [NSString stringWithFormat:@"请到您的%@邮箱进行验证",[AVUser currentUser].email];
                self.resendEmailButton.hidden = NO;
            }
        });
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.sendMailDataArr = [NSMutableArray new];
    self.receiveMailDataArr = [NSMutableArray new];
    self.setMailButton.layer.cornerRadius = 3;
    self.loginButton.layer.cornerRadius = 3;
    isButtonClicked = NO;
    AVUser * currentUser = [AVUser currentUser];
    if (currentUser) {
        [self checkEmailVerified];
    }
    else
    {
        //TODO:need to login or sign up
        self.setMailButton.enabled = YES;
        userStatus = UnRegister;
    }
}

- (void)handleTapGesture:(id)sender {
    self.editing = NO;
}

- (IBAction)clikLogin:(id)sender {
    //TODO:show loading
    [AVUser logInWithUsernameInBackground:self.mailTextField.text password:self.passwordTextField.text block:^(AVUser *user, NSError *error) {
        if (error) {
            [[MailCatUtil singleton] displayToastMsg:@"邮箱或者密码错误" inView:self.view];
            self.descriptionLabel.text = @"邮箱或者密码错误";
        }
        else
        {
            [self checkEmailVerified];
        }
        
    }];
}

//sign up user
- (IBAction)clickMailButton:(id)sender {
//    switch (userStatus) {
//        case UnRegister:
//            if (![self validateEmail:self.mailTextField.text]) {
//                self.descriptionLabel.text = @"请输入正确的邮件";
//            }
//            break;
//        default:
//            break;
//    }
        if (![[MailCatUtil singleton] validateEmail:self.mailTextField.text]) {
            self.descriptionLabel.text = @"请输入正确的邮件";
        }
        else if(self.passwordTextField.text.length < 1)
        {
            self.descriptionLabel.text = @"请输入密码";
        }
        else
        {
            //TODO:show loading view
            [LetterUser signUp:self.mailTextField.text pwd:self.passwordTextField.text withCallback:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"sign up success");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.descriptionLabel.text = @"注册成功,请到您的邮箱进行验证,准备返回";
                        //[self dismissViewControllerAnimated:YES completion:nil];
                    });
                }
                else
                {
                    NSLog(@"sign up faild %@",error);
                    if ([[error.userInfo objectForKey:@"code"] integerValue] == 203) {
                        self.descriptionLabel.text = @"此电子邮箱已经被占用,请重新确认或者登陆,谢谢";
                    }
                }
            }];
        }
        return;
}
- (IBAction)clickResendEmailButton:(id)sender {
    [AVUser requestEmailVerify:[AVUser currentUser].email withBlock:^(BOOL succeeded, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (succeeded) {
                self.descriptionLabel.text = @"邮件重新发送成功,谢谢";
            }
            else
            {
                self.descriptionLabel.text = @"邮件重新发送失败,请稍后再试试哈";
            }
        });
    }];
}

-(void)startLoadingTableView
{
    AVQuery *firstQuery = [AVQuery queryWithClassName:@"LetterData"];
    [firstQuery whereKey:@"sendToEmail" equalTo:[AVUser currentUser].email];
    
    AVQuery* anotherQuery = [AVQuery queryWithClassName:@"LetterData"];
    [anotherQuery whereKey:@"senderEmail" equalTo:[AVUser currentUser].email];
    
    //because the user probably send letter without registration
    NSString* randomEmail = [[NSUserDefaults standardUserDefaults]objectForKey:@"randomEmail"];
    AVQuery* batchQuery;
    if (randomEmail) {
        AVQuery* randomEmailQuery = [AVQuery queryWithClassName:@"LetterData"];
       [randomEmailQuery whereKey:@"senderEmail" equalTo:randomEmail];
        batchQuery = [AVQuery orQueryWithSubqueries:@[firstQuery,anotherQuery,randomEmailQuery]];
    }
    else
    {
        batchQuery = [AVQuery orQueryWithSubqueries:@[firstQuery,anotherQuery]];
    }
    
    
    [batchQuery orderByDescending:@"receiveDate"];
    [batchQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.mailDataArr = [NSArray arrayWithArray:objects];
        
        [objects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary* item = (NSDictionary*)obj;
            if ([[item objectForKey:@"sendToEmail"] isEqualToString:[AVUser currentUser].email]) {
                [self.receiveMailDataArr addObject:item];
            }
            else
            {
                [self.sendMailDataArr addObject:item];
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return @"收到的信件";
    }
    return @"发送的信件";
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return self.receiveMailDataArr.count;
    }
    return self.sendMailDataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MailTableViewCell* cell = (MailTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"reuseMailCell"];
    NSDictionary* item;
    if (indexPath.section == 1) {
        item = [self.receiveMailDataArr objectAtIndex:indexPath.row];
    }
    else
    {
        item = [self.sendMailDataArr objectAtIndex:indexPath.row];
    }
    
    
    cell.senderMailLabel.text  =[item objectForKey:@"senderEmail"]?:@"someone";
    NSDate* avaiableDate = [item objectForKey:@"receiveDate"];
    
    NSUInteger dayLeft = [[MailCatUtil singleton]calcuateLeftDays:avaiableDate];
    
    cell.timeNeededLabel.text =[NSString stringWithFormat:@"预计需要%lu天到达",dayLeft + 1];
    NSString* fullContent = [item objectForKey:@"letterBody"];
    NSString* receiverName = [item objectForKey:@"receiverName"];
    NSString* clipContent = [NSString stringWithFormat:@"%@:\n%@...",receiverName,[fullContent substringWithRange:NSMakeRange(0, fullContent.length <50?fullContent.length - 1:50)]];
    cell.clipContentLabel.text = clipContent;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        //read letter
        ResultViewController* resultViewController = (ResultViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"resultViewController"];
        LetterModel* letterModel = [[LetterModel alloc]initWithDic:[self.receiveMailDataArr objectAtIndex:indexPath.row]];
        resultViewController.letterModel = letterModel;
        [self presentViewController:resultViewController animated:YES completion:^{
            resultViewController.sendButton.hidden = YES;
        }];
    }
    //send letter
    else
    {
        LetterStatusViewController* letterStatusViewController = (LetterStatusViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"letterStautsViewController"];
        LetterModel* letterModel = [[LetterModel alloc]initWithDic:[self.sendMailDataArr objectAtIndex:indexPath.row]];
        letterStatusViewController.letterModel = letterModel;
        [self presentViewController:letterStatusViewController animated:YES completion:nil];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)dimissVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
