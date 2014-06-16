//
//  AppFunctionalityView.h
//  Poem
//
//  Created by Lanston Peng on 6/14/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AppFunctionalityDelegate <NSObject>
- (void)MailDidDismiss;
@end

@interface AppFunctionalityView : UIView

@property(strong,nonatomic)id<AppFunctionalityDelegate>delegate;
@end

