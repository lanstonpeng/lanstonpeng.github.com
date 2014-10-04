//
//  AppCollectionViewCell.m
//  OneThingWell
//
//  Created by Lanston Peng on 9/29/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "AppCollectionViewCell.h"
#import "AppDataManipulator.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface AppCollectionViewCell()

@property (strong,nonatomic)UIView* maskView;

@property (strong,nonatomic)UIImageView* appImageView;

@property (strong, nonatomic) UIScrollView *tagScrollView;

@end

@implementation AppCollectionViewCell

- (IBAction)clickFavButton:(id)sender {
    self.cellDataModel.isFav = !self.cellDataModel.isFav;
    UIImage* img;
    if (self.cellDataModel.isFav) {
        img = [UIImage imageNamed:@"star_selected"];
        NSLog(@"isFav");
    }
    else
    {
        img = [UIImage imageNamed:@"star_deselected"];
        NSLog(@"is not Fav");
    }
    //self.favButton.imageView.image = [UIImage imageNamed:self.cellDataModel.isFav? @"star_selected": @"star_deselected"];
    //self.favButton.imageView.image = img;
    [self.favButton setImage:img forState:UIControlStateNormal];
    if (self.cellDataModel.isFav == NO) {
        [[AppDataManipulator singleton]deleteAnItem:self.cellDataModel];
    }
    else
    {
        [[AppDataManipulator singleton]addAnItem:self.cellDataModel];
    }
    [self setNeedsDisplay];
}

- (void)configureCellData{
    self.appTitle.text = self.cellDataModel.appName;
    self.appDescriptionTextView.text = self.cellDataModel.appDescription;
    [self centerTextView];
    self.pubTimeLabel.text = self.cellDataModel.pubTimeStr;
    UIImage* img = [UIImage imageNamed:self.cellDataModel.isFav ? @"star_selected": @"star_deselected"];
    [self.favButton setImage:img forState:UIControlStateNormal];
    
    if(self.cellDataModel.screenShoot)
    {
        self.appImageView.image = self.cellDataModel.screenShoot;
    }
    else
    {
        self.appImageView.image = nil;
    }
    [self addTags:self.cellDataModel.tags];
}
- (void)configureCellUI{
    
    CGRect cellFrame = [self frame];
    CGSize cellSize = cellFrame.size;
    
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = NO;
    //dynamic change the maskView,imageView,contentTextView
    if (self.maskView == nil) {
        //UIView* maskView = [[UIView alloc]initWithFrame:CGRectMake(-6, cellSize.height*0.25, cellSize.width + 12, cellSize.height*0.6)];
        UIView* maskView = [[UIView alloc]initWithFrame:CGRectMake(0, cellSize.height * 0.25, cellSize.width, cellSize.height*0.6)];
        //maskView.backgroundColor = UIColorFromRGB(0x443D49);
        maskView.backgroundColor = UIColorFromRGB(0xD8D8D8);
        //maskView.alpha = 0.7;
        maskView.alpha = 0.13;
        [self addSubview:maskView];
        self.maskView = maskView;
        
        //add seperator line
        UIView* seperatorLineTop = [[UIView alloc]initWithFrame:CGRectMake(0,0, maskView.frame.size.width, 1)];
        seperatorLineTop.backgroundColor = [UIColor grayColor];
        seperatorLineTop.alpha = 0.5;
        UIView* seperatorLineBottom = [[UIView alloc]initWithFrame:CGRectMake(0,maskView.frame.size.height, maskView.frame.size.width, 1)];
        seperatorLineBottom.backgroundColor = [UIColor grayColor];
        seperatorLineBottom.alpha = 0.5;
        [maskView addSubview:seperatorLineTop];
        [maskView addSubview:seperatorLineBottom];
        
    }
    if (self.tagScrollView == nil)
    {
        //self.tagScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(self.frame.size.width * 0.3, self.maskView.frame.origin.y + self.maskView.frame.size.height , self.frame.size.width * 0.7, 30)];
        CGFloat bottomHeight = self.frame.size.height - ( self.maskView.frame.origin.y + self.maskView.frame.size.height);
        
        self.tagScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(self.frame.size.width * 0.3, self.maskView.frame.origin.y + self.maskView.frame.size.height + bottomHeight/2 - 12, self.frame.size.width * 0.7, 30)];
        //self.tagScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(self.frame.size.width * 0.3, self.frame.size.height - 27, self.frame.size.width * 0.7, 30)];
        self.tagScrollView.backgroundColor = [UIColor clearColor];
        self.tagScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.tagScrollView];
    }
    
    if (self.appDescriptionTextView == nil) {
        UITextView* textView = [[UITextView alloc]initWithFrame:self.maskView.frame];
        //textView.textColor = [UIColor whiteColor];
        textView.textColor = UIColorFromRGB(0x929292);
        textView.scrollEnabled = NO;
        textView.backgroundColor = [UIColor clearColor];
        textView.editable = NO;
        textView.userInteractionEnabled = NO;
        [self addSubview:textView];
        self.appDescriptionTextView = textView;
    }
    
    if (self.appImageView == nil) {
        UIImageView* imgView = [[UIImageView alloc]initWithFrame:self.maskView.bounds];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;
        self.appImageView = imgView;
        [self.maskView addSubview:imgView];
    }
}

- (void)addTags:(NSArray*)tags{
    __block CGFloat offset = 0;
    self.tagScrollView.contentSize = CGSizeZero;
    
    [[self.tagScrollView subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [(UIView*)obj removeFromSuperview];
    }];
    [tags enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UILabel* tagLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, 5, 100, 20)];
        tagLabel.numberOfLines = 1;
        tagLabel.text = (NSString*)obj;
        tagLabel.backgroundColor = [UIColor whiteColor];
        tagLabel.font = [UIFont systemFontOfSize:10];
        [tagLabel sizeToFit];
        tagLabel.frame = CGRectOffset(tagLabel.frame, offset, 0);
        tagLabel.frame = CGRectInset(tagLabel.frame, -5, -4);
        tagLabel.frame = CGRectOffset(tagLabel.frame, 2.5, 2);
        tagLabel.textAlignment = NSTextAlignmentCenter;
        tagLabel.layer.cornerRadius = 8;
        tagLabel.layer.borderWidth = 1;
        tagLabel.layer.borderColor = [UIColor orangeColor].CGColor;
        tagLabel.layer.masksToBounds = YES;
        offset += tagLabel.frame.size.width + 5;
        [self.tagScrollView addSubview:tagLabel];
        self.tagScrollView.contentSize = CGSizeMake(self.tagScrollView.contentSize.width + tagLabel.frame.size.width + 5, 30);
    }];
    if (self.tagScrollView.contentSize.width < self.tagScrollView.frame.size.width) {
        NSLog(@"resize conetentOffset");
        self.tagScrollView.contentOffset = CGPointMake(- (self.tagScrollView.frame.size.width - self.tagScrollView.contentSize.width), 0);
    }
    else
    {
        NSLog(@"won't resize conetentOffset");
    }
}

- (void)centerTextView
{
    NSTextContainer* textContainer  = self.appDescriptionTextView.textContainer;
    NSLayoutManager* layoutManager = textContainer.layoutManager;
    
    CGRect textRect = [layoutManager usedRectForTextContainer:textContainer];
    
    UIEdgeInsets inset = UIEdgeInsetsZero;
    inset.top = self.appDescriptionTextView.bounds.size.height / 2 - textRect.size.height / 2;
    self.appDescriptionTextView.textContainerInset = inset;
}
@end
