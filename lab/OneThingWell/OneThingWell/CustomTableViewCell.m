//
//  CustomTableViewCell.m
//  OneThingWell
//
//  Created by Lanston Peng on 9/24/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "CustomTableViewCell.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface CustomTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *tagViewContainer;
@end

@implementation CustomTableViewCell

- (void)awakeFromNib {
    self.textView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRow:(NSUInteger)row
{
    _row = row;
    self.backgroundColor = [self getBackgroundColor];
//    UIView* spaceView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20)];
//    spaceView.backgroundColor = [UIColor whiteColor];
//    [self addSubview:spaceView];
}

- (void)addTags:(NSArray*)tags{
    __block CGFloat offset = 0;
    
    [[self.tagViewContainer subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [(UIView*)obj removeFromSuperview];
    }];
    
    [tags enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UILabel* tagLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
        tagLabel.numberOfLines = 1;
        tagLabel.text = (NSString*)obj;
        tagLabel.backgroundColor = [UIColor whiteColor];
        tagLabel.font = [UIFont systemFontOfSize:10];
        [tagLabel sizeToFit];
        tagLabel.frame = CGRectOffset(tagLabel.frame, offset, 0);
        tagLabel.frame = CGRectInset(tagLabel.frame, -5, -5);
        tagLabel.textAlignment = NSTextAlignmentCenter;
        tagLabel.layer.cornerRadius = 4;
        tagLabel.layer.borderWidth = 1;
        tagLabel.layer.borderColor = [UIColor orangeColor].CGColor;
        tagLabel.layer.masksToBounds = YES;
        offset += tagLabel.frame.size.width + 5;
        [self.tagViewContainer addSubview:tagLabel];
    }];
}

- (UIColor*)getBackgroundColor
{
    return [UIColor whiteColor];
    /*
    switch (_row % 3) {
        case 0:
            return UIColorFromRGB(0x7C56E4);
            break;
        case 1:
            return UIColorFromRGB(0xF1B136);
            break;
        case 2:
            return UIColorFromRGB(0x76DAB2);
            break;
            
        default:
            return UIColorFromRGB(0x7C56E4);
            break;
    }
     */
}
@end
