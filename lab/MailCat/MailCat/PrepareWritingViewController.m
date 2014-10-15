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

@interface PrepareWritingViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *startWritingBtn;
@property (weak, nonatomic) IBOutlet UIPickerView *senderCityPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *receiverPickerView;


@property (strong,nonatomic)LetterModel* letterModel;
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
    
    self.letterModel = [LetterModel new];
    
    chinaProvinceArr =  @[@"河北省", @"山西省", @"辽宁省", @"吉林省", @"黑龙江省", @"江苏省", @"浙江省", @"安徽省", @"福建省", @"江西省", @"山东省", @"河南省", @"湖北省", @"湖南省", @"广东省", @"海南省", @"四川省", @"贵州省", @"云南省", @"陕西省", @"甘肃省",@"青海省", @"台湾省", @"内蒙古自治区", @"广西壮族自治区", @"西藏自治区", @"宁夏回族自治区", @"新疆维吾尔自治区", @"香港特别行政区", @"澳门特别行政区"];
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //TODO:check form is finished
    self.letterModel.sendToEmail = self.emailTextField.text;
    WritingViewController* writingVC = (WritingViewController*)segue.destinationViewController;
    writingVC.letterModel = self.letterModel;
}
- (IBAction)pickSenderCity:(id)sender {
    //TODO:show pickerview
    //TODO:change the popup button color
}
- (IBAction)pickReceiverCity:(id)sender {
    //TODO:show pickerview
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

- (BOOL)prefersStatusBarHidden
{
    return YES;
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
