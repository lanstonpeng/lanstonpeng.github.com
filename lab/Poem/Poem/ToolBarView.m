//
//  ToolBarView.m
//  Poem
//
//  Created by Lanston Peng on 5/30/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "ToolBarView.h"

@interface ToolBarView()

@property (strong,nonatomic)UIButton* translatedBtn;
@property (strong,nonatomic)UIButton* backgroundImageBtn;
@property (strong,nonatomic)UIButton* colorSchemeBtn;

@property (strong,nonatomic) UIDynamicAnimator* animator;
@end
@implementation ToolBarView

- (UIButton *)translatedBtn
{
    if(!_translatedBtn)
    {
        _translatedBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        [_translatedBtn setTitle:@"g" forState:UIControlStateNormal];
        [self setButtonStyle:_translatedBtn];
    }
    return _translatedBtn;
}
- (UIButton *)backgroundImageBtn
{
    if(!_backgroundImageBtn)
    {
        _backgroundImageBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 0, 50, 50)];
        [_backgroundImageBtn setTitle:@"p" forState:UIControlStateNormal];
        [self setButtonStyle:_backgroundImageBtn];
    }
    return _backgroundImageBtn;
}
- (UIButton *)colorSchemeBtn
{
    if(!_colorSchemeBtn)
    {
        _colorSchemeBtn = [[UIButton alloc]initWithFrame:CGRectMake(150, 0, 50, 50)];
        [_colorSchemeBtn setTitle:@"e" forState:UIControlStateNormal];
        [self setButtonStyle:_colorSchemeBtn];
    }
    return _colorSchemeBtn;
}

-(void)setButtonStyle:(UIButton*)btn
{
    btn.layer.cornerRadius = 25;
    btn.titleLabel.font = [UIFont fontWithName:@"icomoonlight" size:28];
    btn.titleLabel.textColor = [UIColor blackColor];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
        self.backgroundColor = [UIColor orangeColor];
        [self addSubview:self.translatedBtn];
        [self addSubview:self.backgroundImageBtn];
        [self addSubview:self.colorSchemeBtn];
        
    }
    return self;
}
-(void)showSettingButton
{
     //UIGravityBehavior* gravityBeahvior = [[UIGravityBehavior alloc] initWithItems:@[self.translatedBtn]];
    //[_animator addBehavior:gravityBeahvior];
    //UIAttachmentBehavior* attachmentBehavior = [[UIAttachmentBehavior alloc]initWithItem:self.backgroundImageBtn attachedToItem:self.translatedBtn];
    
    //[_animator addBehavior:attachmentBehavior];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _translatedBtn.frame = CGRectMake(30, 0, 50, 50);
    } completion:^(BOOL finished) {
    }];
    
    [UIView animateWithDuration:0.2 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _backgroundImageBtn.frame = CGRectMake(130, 0, 50, 50);
    } completion:^(BOOL finished) {
    }];
}
-(void)hideSettingButton
{}
@end
