//
//  AppCollectionViewCell.m
//  OneThingWell
//
//  Created by Lanston Peng on 9/29/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "AppCollectionViewCell.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface AppCollectionViewCell()

@property (strong,nonatomic)UIView* maskView;


@property (strong,nonatomic)UIImageView* appImageView;

@end

@implementation AppCollectionViewCell


- (void)configureCellData{
    self.appTitle.text = self.cellDataModel.appName;
    self.appDescriptionTextView.text = self.cellDataModel.appDescription;
    [self centerTextView];
}
- (void)configureCellUI{
    
    CGRect cellFrame = [self frame];
    CGSize cellSize = cellFrame.size;
    
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = NO;
    //dynamic change the maskView,imageView,contentTextView
    if (self.maskView == nil) {
        UIView* maskView = [[UIView alloc]initWithFrame:CGRectMake(-6, cellSize.height*0.25, cellSize.width + 12, cellSize.height*0.6)];
        
       
        maskView.backgroundColor = UIColorFromRGB(0x443D49);
        [self addSubview:maskView];
        self.maskView = maskView;
    }
    if (self.appDescriptionTextView == nil) {
        UITextView* textView = [[UITextView alloc]initWithFrame:self.maskView.frame];
        textView.textColor = [UIColor whiteColor];
        textView.scrollEnabled = NO;
        textView.text = @"sucker again";
        textView.backgroundColor = [UIColor clearColor];
        textView.editable = NO;
        textView.userInteractionEnabled = NO;
        [self addSubview:textView];
        self.appDescriptionTextView = textView;
    }
    
    if (self.appImageView == nil) {
        UIImageView* imgView = [[UIImageView alloc]initWithFrame:self.maskView.frame];
        self.appImageView = imgView;
        [self addSubview:imgView];
    }
    else
    {
        //setting the img view
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
