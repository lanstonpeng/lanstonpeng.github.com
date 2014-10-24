//
//  WritingTextView.m
//  MailCat
//
//  Created by Lanston Peng on 10/24/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "WritingTextView.h"

#define DEFAULT_HORIZONTAL_COLOR    [UIColor colorWithRed:0.722f green:0.910f blue:0.980f alpha:0.7f]
#define DEFAULT_VERTICAL_COLOR      [UIColor colorWithRed:0.957f green:0.416f blue:0.365f alpha:0.7f]
#define DEFAULT_MARGINS             UIEdgeInsetsMake(10.0f, 10.0f, 0.0f, 10.0f)
@interface WritingTextView()<UITextViewDelegate>

@property (nonatomic, strong) UIColor *horizontalLineColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *verticalLineColor UI_APPEARANCE_SELECTOR;

@property (nonatomic) UIEdgeInsets margins UI_APPEARANCE_SELECTOR;

@end

@implementation WritingTextView

+ (void)initialize
{
    if (self == [WritingTextView class])
    {
        id appearance = [self appearance];
        [appearance setContentMode:UIViewContentModeRedraw];
        [appearance setHorizontalLineColor:DEFAULT_HORIZONTAL_COLOR];
        [appearance setVerticalLineColor:DEFAULT_VERTICAL_COLOR];
        [appearance setMargins:DEFAULT_MARGINS];
    }
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:0.6f alpha:1.0f];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, self.horizontalLineColor.CGColor);
    CGContextSetLineWidth(context, 1.0f);
    CGContextBeginPath(context);
    
    
    CGFloat boundsX = self.bounds.origin.x;
    CGFloat boundsWidth = self.bounds.size.width;
    CGFloat baselineOffset = 5.0f + self.font.descender;
    CGFloat screenScale = [UIScreen mainScreen].scale;
    CGFloat fontLineHeight = self.font.lineHeight + 10;
    
    
    NSInteger firstVisibleLine = MAX(1, (self.contentOffset.y / self.font.lineHeight));
    NSInteger lastVisibleLine = ceilf((self.contentOffset.y + self.bounds.size.height) / self.font.lineHeight);
    
    for (NSInteger line = firstVisibleLine; line <= lastVisibleLine; ++line)
    {
        CGFloat linePointY = (baselineOffset + (fontLineHeight * line));
        CGFloat roundedLinePointY = roundf(linePointY * screenScale) / screenScale;
        CGContextMoveToPoint(context, boundsX, roundedLinePointY);
        CGContextAddLineToPoint(context, boundsWidth, roundedLinePointY);
    }
    CGContextClosePath(context);
    CGContextStrokePath(context);
    if (self.verticalLineColor)
    {
        CGContextBeginPath(context);
        CGContextSetStrokeColorWithColor(context, self.verticalLineColor.CGColor);
        CGContextMoveToPoint(context, 4.0f, self.contentOffset.y);
        CGContextAddLineToPoint(context, 4.0f, self.contentOffset.y + self.bounds.size.height);
        
        CGContextMoveToPoint(context, 8.0f, self.contentOffset.y);
        CGContextAddLineToPoint(context, 8.0f, self.contentOffset.y + self.bounds.size.height);
        CGContextClosePath(context);
        CGContextStrokePath(context);
    }
}

#pragma mark - Property methods

- (void)setHorizontalLineColor:(UIColor *)horizontalLineColor
{
    _horizontalLineColor = horizontalLineColor;
    [self setNeedsDisplay];
}

- (void)setVerticalLineColor:(UIColor *)verticalLineColor
{
    _verticalLineColor = verticalLineColor;
    [self setNeedsDisplay];
}

- (void)setMargins:(UIEdgeInsets)margins
{
//    _margins = margins;
//    self.contentInset = (UIEdgeInsets) {
//        .top = self.margins.top,
//        .left = self.margins.left,
//        .bottom = self.margins.bottom,
//        .right = self.margins.right - self.margins.left
//    };
//    [self setContentSize:self.contentSize];
}

@end
