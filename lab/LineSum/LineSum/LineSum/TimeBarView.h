//
//  TimeBar.h
//  LineSum
//
//  Created by Lanston Peng on 4/19/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceInfo.h"

@protocol TimeBarDelegate <NSObject>
@optional
-(void)onTimesUp;
@end
@interface TimeBarView : UIView
@property (strong,nonatomic)id<TimeBarDelegate> delegate;
@property (nonatomic)double percentage;
-(void)dropProgressByPersentage:(double)delta;
-(void)addProgressByPersentage:(double)delta;

@end
