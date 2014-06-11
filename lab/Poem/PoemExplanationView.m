//
//  PoemExplanationView.m
//  Poem
//
//  Created by Lanston Peng on 6/4/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "PoemExplanationView.h"
#import "UIImage+PoemResouces.h"
#import <QuartzCore/QuartzCore.h>

#define ExplanationFont @"HelveticaNeue-Thin"
#define verticalMargin 10


@interface PoemExplanationView()

@property (strong,nonatomic)UILabel* explanationLabel;

@end
@implementation PoemExplanationView

- (void)setExplanationData:(NSString *)explanationData
{
    _explanationLabel.text = explanationData;
    //CGSize expectedLabelSize = [explanationData sizeWithAttributes:@{NSFontAttributeName:_explanationLabel.font}];
    CGSize expectedLabelSize = [explanationData boundingRectWithSize:(CGSize){320, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName:_explanationLabel.font} context:nil].size;
    CGRect newFrame = self.frame;
    float height = expectedLabelSize.height + 3*verticalMargin;
    newFrame.origin.y = -height-10;
    newFrame.size.height = height;
    _explanationLabel.frame =CGRectMake(0, 0 , newFrame.size.width, newFrame.size.height);
    
    [self setFrame:newFrame];
    
    CALayer* shadow = self.layer;
    shadow.shadowOffset = CGSizeMake(0, 2);
    shadow.shadowPath = [[UIBezierPath bezierPathWithRect:shadow.bounds]  CGPath];
    //shadow.shadowPath = [self awesomeShadow:shadow.bounds];
    shadow.shadowRadius = 2.0f;
    [shadow setShadowColor:[UIColor blackColor].CGColor];
    [shadow setShadowOpacity:0.5];
    
}
- (id)initWithFrame:(CGRect)frame withExplanation:(NSString*)explanation
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xF9F8F4);
        _explanationData = explanation;
        _explanationLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, frame.size.width, frame.size.height)];
        //_explanationTextView.editable = NO;
        _explanationLabel.text = _explanationData;
        _explanationLabel.textColor = UIColorFromRGB(0x4F4F4D);
        _explanationLabel.textAlignment = NSTextAlignmentCenter;
        _explanationLabel.font = [UIFont fontWithName:ExplanationFont size:14];
        _explanationLabel.layer.cornerRadius = 4;
        _explanationLabel.numberOfLines = 0;
        
        [self addSubview:_explanationLabel];
        self.isOpen = NO;
        
    }
    return self;
}
- (CGPathRef)awesomeShadow:(CGRect)rect
{
    CGSize size = rect.size;
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointZero];
    [path addLineToPoint:CGPointMake(size.width, 0.0f)];
    [path addLineToPoint:CGPointMake(size.width, size.height + 15.0f)];
    
    [path addCurveToPoint:CGPointMake(0.0, size.height + 15.0f)
            controlPoint1:CGPointMake(size.width - 15.0f, size.height)
            controlPoint2:CGPointMake(15.0f, size.height)];
    
    return path.CGPath;
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
