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
#import "MBProgressHUD.h"

@interface InboxViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *setMailButton;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UITextField *mailTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic)NSArray* mailDataArr;

@end

@implementation InboxViewController
{
    BOOL isButtonClicked;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.setMailButton.layer.cornerRadius = 3;
    self.setMailButton.enabled = NO;
    isButtonClicked = NO;
    NSString* email = [[NSUserDefaults standardUserDefaults]objectForKey:@"userEmail"];
    if (email) {
        [LetterUser checkUserVerfied:^(BOOL isVerified) {
            dispatch_async(dispatch_get_main_queue(),^{
                if (isVerified) {
                    self.descriptionLabel.text = @"邮箱已经验证";
                    self.setMailButton.hidden = YES;
                    self.tableView.hidden = NO;
                    [self startLoadingTableView];
                }
                else
                {
                    self.descriptionLabel.text = [NSString stringWithFormat:@"请到您的%@邮箱进行验证",email];
                    //self.setMailButton.enabled = YES;
                }
            });
        }];
    }
    else
    {
        self.setMailButton.enabled = YES;
    }
}
- (IBAction)handleTapGesture:(id)sender {
    self.editing = NO;
}

- (IBAction)clickMailButton:(id)sender {
    if (isButtonClicked) {
        if (![self validateEmail:self.mailTextField.text]) {
            self.descriptionLabel.text = @"请输入正确的邮件";
        }
        else
        {
            //TODO:show loading view
            [LetterUser signUp:self.mailTextField.text withCallback:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"sign up success");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.descriptionLabel.text = @"设置成功,请到您的邮箱进行验证";
                    });
                }
                else
                {
                    NSLog(@"sign up faild %@",error);
                }
            }];
        }
        return;
    }
    self.mailTextField.hidden = NO;
    [self.setMailButton setTitle:@"好了" forState:UIControlStateNormal];
    isButtonClicked = YES;
}

-(void)startLoadingTableView
{
    NSString* email = [[NSUserDefaults standardUserDefaults]objectForKey:@"userEmail"];
    
    AVQuery *query = [AVQuery queryWithClassName:@"LetterData"];
    [query whereKey:@"sendToEmail" equalTo:email];
    //[query whereKey:@"receiveDate" lessThanOrEqualTo:[NSDate new]];
    [query orderByDescending:@"receiveDate"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.mailDataArr = [NSArray arrayWithArray:objects];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mailDataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MailTableViewCell* cell = (MailTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"reuseMailCell"];
    cell.textLabel.text = [[self.mailDataArr objectAtIndex:indexPath.row]objectForKey:@"senderEmail"]?:@"someone";
    NSDate* avaiableDate = [[self.mailDataArr objectAtIndex:indexPath.row]objectForKey:@"receiveDate"];
    
    NSUInteger dayLeft = [self calcuateLeftDays:avaiableDate];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"预计需要%lu天到达",dayLeft + 1];
    return cell;
}

- (NSUInteger)calcuateLeftDays:(NSDate*)avaiableDate
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:[NSDate new]
                                                          toDate:avaiableDate
                                                         options:0];
    return [components day];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

- (IBAction)dimissVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
