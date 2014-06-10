//
//  PoemExplanationView.m
//  Poem
//
//  Created by Lanston Peng on 6/4/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "PoemExplanationView.h"

#define ExplanationFont @"HelveticaNeue-Thin"


@interface PoemExplanationView()

@property (strong,nonatomic)UILabel* explanationLabel;

@end
@implementation PoemExplanationView

- (void)setExplanationData:(NSString *)explanationData
{
    _explanationLabel.text = explanationData;
    //CGSize expectedLabelSize = [explanationData sizeWithAttributes:@{NSFontAttributeName:_explanationLabel.font}];
    CGSize expectedLabelSize = [explanationData boundingRectWithSize:(CGSize){320, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName:_explanationLabel.font} context:nil].size;
    CGRect newFrame = [_explanationLabel frame];
    newFrame.size.height = expectedLabelSize.height;
    [_explanationLabel setFrame:newFrame];
}
- (id)initWithFrame:(CGRect)frame withExplanation:(NSString*)explanation
{
    self = [super initWithFrame:frame];
    if (self) {
        _explanationData = explanation;
        _explanationLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, frame.size.width, frame.size.height)];
        //_explanationTextView.editable = NO;
        _explanationLabel.text = _explanationData;
        _explanationLabel.textColor = [UIColor blackColor];
        _explanationLabel.textAlignment = NSTextAlignmentCenter;
        _explanationLabel.font = [UIFont fontWithName:ExplanationFont size:14];
        _explanationLabel.layer.cornerRadius = 4;
        _explanationLabel.numberOfLines = 0;
        
        CALayer* shadow = [CALayer layer];
        self.clipsToBounds = NO;
        shadow.frame = CGRectMake(0, 0, 320, frame.size.height);
        shadow.masksToBounds = NO;
        [shadow setShadowColor:[UIColor blackColor].CGColor];
        [shadow setShadowOpacity:0.8];
        [shadow setShadowOffset:CGSizeMake(0., 2.)];
        [self.layer addSublayer:shadow];
        [self addSubview:_explanationLabel];
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
