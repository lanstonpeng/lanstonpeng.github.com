//
//  PoemSharingView.m
//  Poem
//
//  Created by Lanston Peng on 6/26/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "PoemSharingView.h"
#import "UIImage+PoemResouces.h"
#import "UIImage+ImageEffects.h"
#import "ContainerViewController.h"

@interface PoemSharingView()

@property (nonatomic)BOOL isShowing;
@property (strong,nonatomic) UIButton* sharePoemBtn;
@property (strong,nonatomic) UIImageView* bgView;

@end

@implementation PoemSharingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
    }
    return self;
}
- (UIImageView *)bgView
{
    if(!_bgView)
    {
        _bgView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _bgView;
}
- (UIButton *)sharePoemBtn
{
    if(!_sharePoemBtn)
    {
        CGRect sFrame = [UIScreen mainScreen].bounds;
        _sharePoemBtn = [[UIButton alloc]initWithFrame:CGRectMake(sFrame.size.width/2 - 20, sFrame.size.height/2, 39, 54)];
        [_sharePoemBtn setImage:[[UIImage alloc]initWithName:@"share"] forState:UIControlStateNormal];
        [_sharePoemBtn setImage:[[UIImage alloc]initWithName:@"share_highlight"] forState:UIControlStateSelected | UIControlStateHighlighted];
        [_sharePoemBtn addTarget:self action:@selector(invokeSharingSDK) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sharePoemBtn;
}


#pragma mark share poem
- (void)showShareCurrentPoem
{
    if(!_isShowing){
        CGRect sFrame = [UIScreen mainScreen].bounds;
        UIImage* screenImg = [self cropScreen];
        UIColor *tintColor = [UIColor colorWithWhite:1.0 alpha:0.4];
        self.bgView.image = [screenImg applyBlurWithRadius:10 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:screenImg];
        [self addSubview:self.bgView];
        [self addSubview:self.sharePoemBtn];
        [UIView animateWithDuration:0.4 animations:^{
            _sharePoemBtn.frame = CGRectMake(sFrame.size.width/2 - 20, sFrame.size.height/2 - 54, 39, 54);
        } completion:^(BOOL finished) {
        }];
        _isShowing = YES;
    }
}
- (void)invokeSharingSDK
{
    NSMutableArray *sharingItems = [NSMutableArray new];
    NSURL* url = [[NSURL alloc]initWithString:@"http://lanstonpeng.github.io"];
    [sharingItems addObject:url];
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    activityController.excludedActivityTypes = @[UIActivityTypePrint,UIActivityTypeSaveToCameraRoll,UIActivityTypeAssignToContact, UIActivityTypeAddToReadingList,UIActivityTypeAirDrop];
    [[ContainerViewController sharedViewController] presentViewController:activityController animated:YES completion:nil];
    
    activityController.completionHandler = ^(NSString *activityType, BOOL completed) {
        [[ContainerViewController sharedViewController] dismissViewControllerAnimated:YES completion:nil];
    };
}

-(UIImage*)cropScreen;
{
    CGRect rects = [[UIScreen mainScreen] bounds];
    UIGraphicsBeginImageContextWithOptions(rects.size, NO, [UIScreen mainScreen].scale);
    [self.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGRect f = self.sharePoemBtn.frame;
    if(!CGRectContainsPoint(CGRectInset(f, -10, -10), point))
    {
        //touch the space rather the sharing button
        if([self.delegate respondsToSelector:@selector(dismissPoemSharingView)])
        {
            _isShowing = NO;
            [self.delegate dismissPoemSharingView];
        }
    }
}
@end
