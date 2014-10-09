//
//  PoemListTableViewCell.m
//  Poem
//
//  Created by Lanston Peng on 10/8/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "PoemListTableViewCell.h"

@implementation PoemListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    NSLog(@"awakeFromNib");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initUI
{
    CGRect sFrame = self.frame;
    if (!self.bgImageView) {
        self.bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, sFrame.size.width, sFrame.size.height)];
        self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.bgImageView.clipsToBounds = YES;
        self.bgImageView.alpha = 1;
        
        CALayer* maskLayer = [CALayer layer];
        maskLayer.frame = CGRectMake(0, 0, sFrame.size.width, sFrame.size.height);
        maskLayer.backgroundColor = [UIColor blackColor].CGColor;
        maskLayer.opacity = 0.8;
        [self.bgImageView.layer insertSublayer:maskLayer atIndex:0];
        //[self.bgImageView.layer addSublayer:maskLayer];
        
        [self addSubview:self.bgImageView];
    }
    
    if(!self.titleLabel)
    {
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, sFrame.size.width, sFrame.size.height)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Thin" size:16];
        self.titleLabel.textColor = [UIColor whiteColor];
        
        [self addSubview:self.titleLabel];
    }
    if (!self.authorLabel) {
        self.authorLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, sFrame.size.width, sFrame.size.height)];
        self.authorLabel.backgroundColor = [UIColor clearColor];
        self.authorLabel.textColor = [UIColor whiteColor];
        self.authorLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Thin" size:9];
        
        [self addSubview:self.authorLabel];
    }
    
    self.selectionStyle =  UITableViewCellSelectionStyleNone;
}

- (void)setHighlightCell
{
    //self.backgroundColor = [UIColor grayColor];
    //self.bgImageView.alpha = 0.3;
}

- (void)setDefaultHightlightCell
{
    //self.backgroundColor = [UIColor clearColor];
    //self.bgImageView.alpha = 0.6;
}
- (void)configureCell:(AVObject*)item withIdxPath:(NSIndexPath*)idxPath{
    [self initUI];
    self.titleLabel.text = [item objectForKey:@"title"];
    self.authorLabel.text = [item objectForKey:@"author"];
    [self.authorLabel sizeToFit];
    self.authorLabel.frame = CGRectMake(self.frame.size.width - self.authorLabel.frame.size.width - 10 , self.frame.size.height - self.authorLabel.frame.size.height - 3, self.authorLabel.frame.size.width, self.authorLabel.frame.size.height);
    
    //TODO:cache the image
    AVObject* img = [item objectForKey:@"imgPointer"];
    [img fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        AVFile* file = (AVFile*)[object objectForKey:@"url"];
        [file getThumbnail:YES width:self.frame.size.width height:self.frame.size.height withBlock:^(UIImage *image, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.bgImageView.image = image;
            });
        }];
    }];
}
@end
