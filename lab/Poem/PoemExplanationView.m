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

@property (strong,nonatomic)UITextView* explanationTextView;

@end
@implementation PoemExplanationView

- (void)setExplanationData:(NSString *)explanationData
{
    _explanationTextView.text = explanationData;
}
- (id)initWithFrame:(CGRect)frame withExplanation:(NSString*)explanation
{
    self = [super initWithFrame:frame];
    if (self) {
        _explanationData = explanation;
        _explanationTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _explanationTextView.editable = NO;
        _explanationTextView.text = _explanationData;
        _explanationTextView.textColor = [UIColor blackColor];
        _explanationTextView.textAlignment = NSTextAlignmentCenter;
        _explanationTextView.font = [UIFont fontWithName:ExplanationFont size:14];
        _explanationTextView.layer.cornerRadius = 4;
        [self addSubview:_explanationTextView];
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
