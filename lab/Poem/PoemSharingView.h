//
//  PoemSharingView.h
//  Poem
//
//  Created by Lanston Peng on 6/26/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PoemSharingDelegate <NSObject>
-(void)dismissPoemSharingView;
@end
@interface PoemSharingView : UIView

@property (weak,nonatomic)id<PoemSharingDelegate> delegate;
-(void)showShareCurrentPoem;
@end
