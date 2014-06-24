//
//  PoemIntroductionView.m
//  Poem
//
//  Created by Lanston Peng on 6/2/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "PoemIntroductionView.h"
#import "UIImage+PoemResouces.h"
#import "UIImage+ImageEffects.h"

@interface PoemIntroductionView()<NSLayoutManagerDelegate>

@property (strong,nonatomic)UIScrollView* introductionScrollView;
@property (strong,nonatomic)UIImageView* bgView;
@property (strong,nonatomic)UIView* blackBgView;
@property (strong,nonatomic)NSDictionary* poemData;
@property (strong,nonatomic)UITextView* introTextView;
@end

#define PaddingLeft 20
#define MarginTop 20
@implementation PoemIntroductionView

- (void)setPoemData:(NSDictionary*)poemData
{
    _poemData = poemData;
    _blackBgView.alpha = 1;
    _bgView.image = nil;
    _bgView.alpha = 0;
    _introTextView.text = _poemData[@"poemIntroduction"][@"text"];
    [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(setUpBgView) userInfo:nil repeats:NO];
}
- (void)setUpBgView
{
    UIImage* backgroundImg = (UIImage*)[[UIImage alloc]initWithName:_poemData[@"bgimg"]];
    _bgView.image = [backgroundImg applyDarkEffect];
    //_bgView.image = backgroundImg;
    _bgView.contentMode = UIViewContentModeScaleAspectFill;
    [UIView animateWithDuration:0.9 animations:^{
        _bgView.alpha = 1.0f;
        //_blackBgView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self addParallelEffect];
    }];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGRect sFrame = [UIScreen mainScreen].bounds;
        _introTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, sFrame.size.width, sFrame.size.height)];
        _blackBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, sFrame.size.width, sFrame.size.height)];
        _blackBgView.backgroundColor = [UIColor blackColor];
        _introTextView.font = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:16];
        _introTextView.textAlignment = NSTextAlignmentNatural;
        _introTextView.layoutManager.delegate = self;
        _introTextView.textContainerInset = UIEdgeInsetsMake(20, PaddingLeft, 0, 0);
        _introTextView.showsVerticalScrollIndicator = NO;
        _introTextView.backgroundColor = [UIColor clearColor];
        _introTextView.textColor = [UIColor whiteColor];
        _introTextView.editable = NO;
        _introTextView.selectable = NO;
        CALayer* titleLayer = _introTextView.layer;
        titleLayer.masksToBounds = NO;
        titleLayer.shadowColor = [UIColor blackColor].CGColor;
        [titleLayer setShadowOpacity:1];
        [titleLayer setShadowRadius:0.5];
        [titleLayer setShadowOffset:CGSizeMake(1, 1)];
        self.clipsToBounds = YES;
        _bgView = [[UIImageView alloc]initWithFrame:CGRectMake(-20, 0, sFrame.size.width + 40, sFrame.size.height + 40)];
        _bgView.alpha = 0.0f;
        
        //textView.text = _poemData[@"poemIntroduction"][@"text"];
//        _introductionScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, sFrame.size.width, sFrame.size.height)];
//        _introductionScrollView.showsHorizontalScrollIndicator = NO;
//        _introductionScrollView.showsVerticalScrollIndicator = NO;
//        [_introductionScrollView addSubview:_introTextView];
        [self addSubview:_blackBgView];
        [self addSubview:_bgView];
        [self addSubview:_introTextView];
        //[self addParallelEffect];
        
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
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touching introduction view");
}

-(void)addParallelEffect
{
    // Set vertical effect
    UIInterpolatingMotionEffect *verticalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.y"
     type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    
    verticalMotionEffect.minimumRelativeValue = @(-10);
    verticalMotionEffect.maximumRelativeValue = @(10);
    
    // Set horizontal effect
    UIInterpolatingMotionEffect *horizontalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.x"
     type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-20);
    horizontalMotionEffect.maximumRelativeValue = @(20);
    
    // Create group to combine both
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    // Add both effects to your view
    [_bgView addMotionEffect:group];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    NSLog(@"Introduction View");
    return [super hitTest:point withEvent:event];
}
@end
