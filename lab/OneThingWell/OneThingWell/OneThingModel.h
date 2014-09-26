//
//  OneThingModel.h
//  OneThingWell
//
//  Created by Lanston Peng on 9/24/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OneThingModel : NSObject

@property(strong,nonatomic)NSString* appName;
@property(strong,nonatomic)NSString* appDescription;
@property(strong,nonatomic)NSString* appURL;
@property(strong,nonatomic)UIImage*  screenShoot;
@property(strong,nonatomic)NSString* pubTimeStr;
@property(strong,nonatomic)NSArray*  tags;

@end
