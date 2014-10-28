//
//  LetterInBoxViewController.m
//  MailCat
//
//  Created by Lanston Peng on 10/24/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "LetterInBoxViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "MailTableViewCell.h"
#import "LetterUser.h"
#import "MailCatUtil.h"
#import "LetterStatusViewController.h"
#import "ResultViewController.h"
#import "LetterModel.h"

@interface LetterInBoxViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic)UILabel* progressLabel;

@property (strong,nonatomic)NSArray* mailDataArr;

@property (strong,nonatomic)NSMutableArray* sendMailDataArr;

@property (strong,nonatomic)NSMutableArray* receiveMailDataArr;

@end

@implementation LetterInBoxViewController

- (void)initReleaseView
{
    _progressLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 2)];
    _progressLabel.backgroundColor = UIColorFromRGB(0x19A9E7);
    [self.view addSubview:_progressLabel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initReleaseView];
    self.sendMailDataArr = [NSMutableArray new];
    self.receiveMailDataArr = [NSMutableArray new];
    [[MailCatUtil singleton]showLoadingView:self.view];
    [self startLoadingTableView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
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
        
        
        for (int i = 0 ; i < self.mailDataArr.count; i++) {
            NSDictionary* item = (NSDictionary*)[self.mailDataArr objectAtIndex:i];
            if ([[item objectForKey:@"sendToEmail"] isEqualToString:[AVUser currentUser].email]) {
                [self.receiveMailDataArr addObject:item];
            }
            else
            {
                [self.sendMailDataArr addObject:item];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [[MailCatUtil singleton]hideLodingView];
            self.tableView.delegate = self;
            self.tableView.dataSource = self;
            //[self.tableView reloadData];
        });
    }];
}


//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (section == 1) {
//        return @"收到的信件";
//    }
//    return @"发送的信件";
//    
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 15)];
    //label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    label.font = [UIFont systemFontOfSize:15];
    //label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    if (section == 1) {
        if (self.receiveMailDataArr.count > 0) {
            label.text = @"收到的信件";
        }
        else
        {
            label.text = @"";
        }
    }
    else
    {
        if (self.sendMailDataArr.count > 0) {
            label.text = @"发送的信件";
        }
        else
        {
            label.text = @"";
        }
    }
    return label;
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
    
    
    NSString* userName = [item objectForKey:@"senderEmail"]?:@"someone";
    if ([userName componentsSeparatedByString:@"@"].count > 1) {
        cell.senderMailLabel.text = [userName componentsSeparatedByString:@"@"][0];
    }
    else
    {
        cell.senderMailLabel.text = userName;
    }
    
    NSDate* avaiableDate = [item objectForKey:@"receiveDate"];
    NSUInteger hourLeft = [[MailCatUtil singleton]calcuateLeftDays:avaiableDate];
    if (hourLeft == 0) {
        cell.timeNeededLabel.text = @"信件已送达";
    }
    else
    {
        cell.timeNeededLabel.text =[NSString stringWithFormat:@"预计需要 %lu小时 到达",hourLeft];
    }
    NSString* fullContent = [item objectForKey:@"letterBody"];
    NSString* receiverName = [item objectForKey:@"receiverName"];
    NSString* clipContent = [NSString stringWithFormat:@"%@:\n%@...",receiverName,[fullContent substringWithRange:NSMakeRange(0, fullContent.length <50?fullContent.length - 1:50)]];
    cell.clipContentLabel.text = clipContent;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        LetterModel* letterModel = [[LetterModel alloc]initWithDic:[self.receiveMailDataArr objectAtIndex:indexPath.row]];
        
        //read letter if the letter is arrived
        if([[NSDate new] compare:letterModel.receiveDate] != NSOrderedAscending)
        {
            ResultViewController* resultViewController = (ResultViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"resultViewController"];
            resultViewController.letterModel = letterModel;
            [self presentViewController:resultViewController animated:YES completion:^{
                //TODO:User Experience
                resultViewController.sendButton.hidden = YES;
                //update letter status
                AVObject* item = (AVObject*)[self.receiveMailDataArr objectAtIndex:indexPath.row];
                [item setObject:@(HasRead) forKey:@"letterStatus"];
                [item saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (error) {
                        NSLog(@"update letter error: %@",error);
                    }
                }];
                
            }];
        }
        else
        {
            [[MailCatUtil singleton]displayToastMsg:@"信件还需要一点时间才能送达,请耐心等待" inView:self.view afterDelay:1.5];
            
        }
    }
    //send letter which can't be viewd
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

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y < -100) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //_testLabel.text = [NSString stringWithFormat:@"%d",(int)-scrollView.contentOffset.y];
    
    _progressLabel.frame = CGRectMake(0, 0, (int)-scrollView.contentOffset.y * (self.view.bounds.size.width / 100) ,_progressLabel.frame.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}
@end
