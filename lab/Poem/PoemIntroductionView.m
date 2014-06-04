//
//  PoemIntroductionView.m
//  Poem
//
//  Created by Lanston Peng on 6/2/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "PoemIntroductionView.h"

@interface PoemIntroductionView()<NSLayoutManagerDelegate>

@property (strong,nonatomic)UIScrollView* introudctionScrollView;
@property (strong,nonatomic)NSDictionary* poemData;
@end

#define PaddingLeft 10
#define MarginTop 20
@implementation PoemIntroductionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGRect sFrame = [UIScreen mainScreen].bounds;
        UITextView* textView = [[UITextView alloc]initWithFrame:CGRectMake(PaddingLeft, MarginTop, sFrame.size.width - 2*PaddingLeft, sFrame.size.height - 2 * MarginTop)];
        textView.font = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:16];
        textView.textAlignment = NSTextAlignmentNatural;
        textView.layoutManager.delegate = self;
        textView.text = _poemData[@"poemIntroduction"][@"text"];
        _introudctionScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, sFrame.size.width, sFrame.size.height)];
        _introudctionScrollView.showsHorizontalScrollIndicator = NO;
        [_introudctionScrollView addSubview:textView];
        [self addSubview:_introudctionScrollView];
        
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame withData:(NSDictionary *)poem
{
    _poemData = poem;
    return [self initWithFrame:frame];
}
- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager lineSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect
{
    return 10; // For really wide spacing; pick your own value
}


@end
