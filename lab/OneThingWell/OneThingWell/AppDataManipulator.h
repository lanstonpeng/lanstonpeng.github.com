//
//  AppDataManipulator.h
//  OneThingWell
//
//  Created by Lanston Peng on 9/25/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OneThingModel.h"

@interface AppDataManipulator : NSObject

- (void)saveItem:(OneThingModel*)model;
- (NSArray*)fetchAllSavedItem;
@end
