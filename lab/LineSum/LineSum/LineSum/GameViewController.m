//
//  GameViewController.m
//  LineSum
//
//  Created by Sun Xi on 5/8/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "GameViewController.h"
#import "GameBoardView.h"

@interface GameViewController ()
@property (weak, nonatomic) IBOutlet GameBoardView *gameboardView;

@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_gameboardView layoutBoardWithCellNum:5];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
