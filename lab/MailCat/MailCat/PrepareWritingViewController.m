//
//  PrepareWritingViewController.m
//  MailCat
//
//  Created by Lanston Peng on 10/15/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "PrepareWritingViewController.h"
#import "LetterModel.h"
#import "WritingViewController.h"
#import "MBProgressHUD.h"
#import "TransitionManager.h"
#import <AVOSCloud/AVOSCloud.h>

@interface PrepareWritingViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *startWritingBtn;
@property (weak, nonatomic) IBOutlet UIPickerView *senderCityPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *receiverPickerView;

@property (weak, nonatomic) IBOutlet UILabel *senderCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiverCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *daySpendLabel;

@property (weak, nonatomic) IBOutlet UIButton *senderCityBtn;
@property (weak, nonatomic) IBOutlet UIButton *herEmailButton;
@property (weak, nonatomic) IBOutlet UIButton *receiverCityBtn;
@property (strong,nonatomic)LetterModel* letterModel;

@property (strong,nonatomic)NSTimer* pickerTimer;

@property (strong,nonatomic)MBProgressHUD* toastMsg;
@end

@implementation PrepareWritingViewController
{
    NSArray* chinaProvinceArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.startWritingBtn.layer.cornerRadius = 3;
    self.senderCityPickerView.tag = 100;
    self.receiverPickerView.tag = 200;
    self.storyBoardIdentifier = @"prepareViewController";
    self.letterModel = [LetterModel new];
    
    if ([AVUser currentUser]) {
        self.letterModel.senderEmail = [AVUser currentUser].email;
    }
    else
    {
        NSString* randomEmail = [NSString stringWithFormat:@"cat_%ld@mailcat.com",arc4random()% 10000000000];
        self.letterModel.senderEmail = randomEmail;
        [[NSUserDefaults standardUserDefaults]setObject:randomEmail forKey:@"randomEmail"];
    }
    self.panDirection = UIRectEdgeLeft;
    chinaProvinceArr =  @[@"北京",@"上海",@"广州",@"深圳",@"厦门",@"天津",@"杭州",@"重庆",@"武汉",@"南京",@"苏州",@"无锡",@"成都",@"沈阳",@"长春",@"宁波",@"济南",@"福州",@"长沙",@"郑州",@"青岛",@"大连",@"西安",@"哈尔滨",@"温州"];
    
}


#pragma mark --
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self validateEmail: self.emailTextField.text]) {
        self.letterModel.sendToEmail = self.emailTextField.text;
        [self toggleButton:YES withButton:self.herEmailButton];
    }
    else
    {
        [self toggleButton:NO withButton:self.herEmailButton];
    }
    [self.emailTextField resignFirstResponder];
    return YES;
}

- (void)toggleButton:(BOOL)isGreen withButton:(UIButton*)button
{
    [button setImage:[UIImage imageNamed:isGreen ? @"arrowGreen":@"selectedBtn"] forState:UIControlStateNormal];
}
- (void)displayToastMsg:(NSString*)str
{
    self.toastMsg = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.toastMsg.mode = MBProgressHUDModeText;
    self.toastMsg.labelText = str;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.toastMsg hide:YES];
    });
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return YES;
    if (self.letterModel.senderCity == nil ) {
        [self displayToastMsg:@"请选择你所在城市"];
        return NO;
    }
    if (self.letterModel.receiverCity == nil) {
        [self displayToastMsg:@"请选择她所在城市"];
        return NO;
    }
    if (self.letterModel.sendToEmail == nil || ![self validateEmail:self.letterModel.sendToEmail]) {
        [self displayToastMsg:@"请输入她的邮箱"];
        return NO;
    }
    return YES;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.letterModel.sendToEmail = self.emailTextField.text;
    WritingViewController* writingVC = (WritingViewController*)segue.destinationViewController;
    writingVC.letterModel = self.letterModel;
}
- (IBAction)pickSenderCity:(id)sender {
    self.senderCityPickerView.hidden = NO;
    self.senderCityLabel.hidden = YES;
    //TODO:change the popup button color
}


- (IBAction)pickReceiverCity:(id)sender {
    self.receiverPickerView.hidden = NO;
    self.receiverCityLabel.hidden = YES;
    //TODO:change the popup button color
}

- (IBAction)focusOnEmailTextField:(id)sender {
    [self.emailTextField becomeFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)unwindSegue:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)touchUpOuside:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return chinaProvinceArr.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    NSString* title = [chinaProvinceArr objectAtIndex:row];
    UILabel* tView = (UILabel*)view;
    if (!tView)
    {
        tView = [[UILabel alloc] init];
        [tView setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        tView.numberOfLines = 1;
    }
    tView.text = title;
    return tView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == 100) {
        self.letterModel.senderCity = [chinaProvinceArr objectAtIndex:row];
        
    }
    else if (pickerView.tag  == 200)
    {
        self.letterModel.receiverCity = [chinaProvinceArr objectAtIndex:row];
    }
    [self.pickerTimer invalidate];
    self.pickerTimer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(showPickerResult:) userInfo:@{
                                                                                                                              @"tag":@(pickerView.tag)
                                                                                                                              } repeats:NO];
}

- (void)showPickerResult:(NSTimer*)timer
{
    NSUInteger tag = [[timer.userInfo objectForKey:@"tag"] integerValue];
    if (tag == 100) {
        self.senderCityPickerView.hidden = YES;
        self.senderCityLabel.text = self.letterModel.senderCity;
        self.senderCityLabel.hidden = NO;
        [self toggleButton:YES withButton:self.senderCityBtn];
    }
    else
    {
        self.receiverPickerView.hidden = YES;
        self.receiverCityLabel.text = self.letterModel.receiverCity;
        self.receiverCityLabel.hidden = NO;
        [self toggleButton:YES withButton:self.receiverCityBtn];
    }
    if (self.letterModel.senderCity.length > 0 && self.letterModel.receiverCity.length > 0) {
        
        int dayNeeded = arc4random() % 4 + 2;
        self.daySpendLabel.text = [NSString stringWithFormat:@"信件预计在 %d天后 到达", dayNeeded];
        self.letterModel.receiveDate = [[NSDate alloc]initWithTimeInterval:86400 * dayNeeded sinceDate:[NSDate new]];
    }
}

- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}


#pragma mark --
#pragma mark Transition Animation

//- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator
//{
//    return self.interactiveTransition;
//}
//
//- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
//{
//    return self.interactiveTransition;
//}

//- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
//{
//    if (presented == self) {
//        return (id<UIViewControllerAnimatedTransitioning>)[[TransitionManager alloc]init:YES];
//    }
//    return nil;
//}
//
//- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
//{
//    if (dismissed == self) {
//        return (id<UIViewControllerAnimatedTransitioning>)[[TransitionManager alloc]init:NO];
//    }
//    return nil;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
