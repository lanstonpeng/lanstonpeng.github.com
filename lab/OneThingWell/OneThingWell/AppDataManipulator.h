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


+ (instancetype)singleton;

- (void)saveItem:(OneThingModel*)model;

- (NSArray*)fetchAllSavedItem;

- (void)flushDataToFile;

- (void)addAnItem:(OneThingModel*)model;

- (void)deleteAnItem:(OneThingModel*)model;

- (void)updateAnItem:(OneThingModel*)model;

- (BOOL)isInLocalFav:(NSString*)appID;
@end
