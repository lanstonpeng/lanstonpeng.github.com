//
//  CustomCell.m
//  ParallelScroll
//
//  Created by Lanston Peng on 6/6/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "CustomCell.h"

@interface CustomCell()

@end

@implementation CustomCell

static int currentCount;
-(UIColor*)getRandomColor
{
    //int i = (int)arc4random() % 5;
    int i = currentCount;
    switch (i) {
        case 0:
            return [UIColor orangeColor];
            break;
        case 1:
            return [UIColor redColor];
            break;
        case 2:
            return [UIColor blueColor];
            break;
        case 3:
            return [UIColor yellowColor];
            break;
        case 4:
            return [UIColor purpleColor];
            break;
        default:
            return [UIColor greenColor];
            break;
    }
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if (currentCount>=0) {
            currentCount++;
        }
        else
        {
            currentCount = 0;
        }
        
        self.backgroundColor = [self getRandomColor];
        UILabel* l  = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, 320, 50)];
        l.textColor = [UIColor whiteColor];
        l.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        l.text = [NSString stringWithFormat:@"%@ %d",@"sucker",arc4random() % 100];
        
        UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
        [self addSubview:imgView];
        [self addSubview:l];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:@"http://lorempixel.com/320/568/"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            UIImage* img = [UIImage imageWithData:data];
            imgView.image = img;
        }];
        [dataTask resume];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
