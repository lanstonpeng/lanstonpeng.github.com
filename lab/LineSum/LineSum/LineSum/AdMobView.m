//
//  AdMobView.m
//  LineSum
//
//  Created by Lanston Peng on 5/1/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "AdMobView.h"

@implementation AdMobView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
            GADBannerView *bannerView_;
            /*
            bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
            bannerView_.adUnitID = @"a1535f4f4d34ec5";
            bannerView_.rootViewController = self;
            bannerView_.frame = CGRectMake(0, IPHONE_SCREEN_HEIGHT - bannerView_.frame.size.height, bannerView_.frame.size.width, bannerView_.frame.size.height);
            [self.view addSubview:bannerView_ ];
            bannerView_.delegate = self;
            [bannerView_ loadRequest:[GADRequest request]];
            self.gadBannerView = bannerView_;
            */
    }
    return self;
}

#pragma ADMob delegate
- (void)adViewDidReceiveAd:(GADBannerView *)view{
    NSLog(@"youku");
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
