//
//  EditingTableViewController.m
//  EditingTableView
//
//  Created by Lanston Peng on 5/29/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "EditingTableViewController.h"

@interface EditingTableViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    BOOL isKeyBoardHide;
}

@property (strong,nonatomic)UITableView* tableView;

@property (strong,nonatomic)UILabel* hideKeyBoardIcon;
@end

@implementation EditingTableViewController

- (UILabel *)hideKeyBoardIcon
{
    if(!_hideKeyBoardIcon)
    {
        _hideKeyBoardIcon = [[UILabel alloc]initWithFrame:CGRectZero];
        _hideKeyBoardIcon.font = [UIFont fontWithName:@"icomoon" size:18];
        _hideKeyBoardIcon.text = @"v";
        _hideKeyBoardIcon.textAlignment = NSTextAlignmentCenter;
        //_hideKeyBoardIcon.backgroundColor = [UIColor grayColor];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHideKeyboard)];
        [_hideKeyBoardIcon addGestureRecognizer:tap];
    }
    return _hideKeyBoardIcon;
}
-(void)tapHideKeyboard
{
    [self hideKeyBoard];
    [UIView animateWithDuration:0.2 animations:^{
        _hideKeyBoardIcon.alpha = 0;
    }];
}
- (void)scrollViewDidScroll:(UITableView *)tableView
{
    if(!isKeyBoardHide){
        [self hideKeyBoard];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isKeyBoardHide = YES;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate =  self;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBoard)];
    [self.tableView addGestureRecognizer:tap];
    [self.view addSubview:self.hideKeyBoardIcon];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
}
#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        UITextField* textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, cell.frame.size.width/2 - 10, cell.frame.size.height - 10 )];
        textField.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        textField.font = [UIFont fontWithName:@"icomoon" size:18];
        UILabel* lv=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        lv.font =[UIFont fontWithName:@"icomoon" size:18];
        textField.leftView =lv;
        textField.leftViewMode = UITextFieldViewModeAlways;
        lv.text = @"g";
        textField.delegate = self;
        textField.clearButtonMode = UITextFieldViewModeAlways;
        [cell addSubview:textField];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(UITableViewCell*)getSuperTableViewCell:(UITextField*)textField
{
    id view = [textField superview];
    if(![view isKindOfClass:[UITableViewCell class]])
    {
        view = [view superview];
    }
    return (UITableViewCell*)view;
}
#pragma --mark textfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    UITableViewCell* cell = [self getSuperTableViewCell:textField];
    NSIndexPath* idxPath = [self.tableView indexPathForCell:cell];
    [self.tableView scrollToRowAtIndexPath:idxPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [_tableView setContentInset:UIEdgeInsetsZero];
    } completion:^(BOOL finished) {
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //[textField resignFirstResponder];
    [self hideKeyBoard];
    return YES;
}

#pragma --mark keyboard show/hide stuffs
- (void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    
    //scroll the tableView
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, keyboardFrameBeginRect.size.height, 0);
    [_tableView setContentInset:inset];
    self.hideKeyBoardIcon.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 20,[UIScreen mainScreen].bounds.size.height -  keyboardFrameBeginRect.size.height, 20 , 20);
    self.hideKeyBoardIcon.alpha = 0;
}
- (void)keyboardDidShow:(NSNotification*)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    [UIView animateWithDuration:0.2 animations:^{
        self.hideKeyBoardIcon.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 20,[UIScreen mainScreen].bounds.size.height -  keyboardFrameBeginRect.size.height - 20, 20 , 20);
        self.hideKeyBoardIcon.alpha = 1;
    } completion:^(BOOL finished) {
        isKeyBoardHide = NO;
    }];
    
}
-(void)hideKeyBoard
{
    self.hideKeyBoardIcon.alpha = 0;
    [self.view endEditing:YES];
    isKeyBoardHide = YES;
}

@end
