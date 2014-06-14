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
@property (strong,nonatomic)UITextView* introTextView;
@end

#define PaddingLeft 20
#define MarginTop 20
@implementation PoemIntroductionView

- (void)setPoemData:(NSDictionary*)poemData
{
    _poemData = poemData;
    _introTextView.text = _poemData[@"poemIntroduction"][@"text"];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGRect sFrame = [UIScreen mainScreen].bounds;
        _introTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, sFrame.size.width, sFrame.size.height)];
        _introTextView.font = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:16];
        _introTextView.textAlignment = NSTextAlignmentNatural;
        _introTextView.layoutManager.delegate = self;
        _introTextView.textContainerInset = UIEdgeInsetsMake(20, PaddingLeft, 0, 0);
        //textView.text = _poemData[@"poemIntroduction"][@"text"];
        _introudctionScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, sFrame.size.width, sFrame.size.height)];
        _introudctionScrollView.showsHorizontalScrollIndicator = NO;
        [_introudctionScrollView addSubview:_introTextView];
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
