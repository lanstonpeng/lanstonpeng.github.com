//
//  AppDataManipulator.m
//  OneThingWell
//
//  Created by Lanston Peng on 9/25/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "AppDataManipulator.h"

@implementation AppDataManipulator


- (void)saveItem:(OneThingModel *)model
{
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:@"fav_app.dat"];
    NSData* modelData;
    if ([fileManager fileExistsAtPath:fullPath]) {
        NSMutableArray* existsFavData = (NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithFile:fullPath];
        [existsFavData addObject:model];
        modelData = [NSKeyedArchiver archivedDataWithRootObject:existsFavData];
    }
    else
    {
        NSMutableArray* newFavData = [[NSMutableArray alloc]init];
        [newFavData addObject:model];
        modelData = [NSKeyedArchiver archivedDataWithRootObject:newFavData];
    }
    [fileManager createFileAtPath:fullPath contents:modelData attributes:nil];
}
- (NSArray*)fetchAllSavedItem{

    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:@"fav_app.dat"];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:fullPath]) {
        return (NSArray*)[NSKeyedUnarchiver unarchiveObjectWithFile:fullPath];
    }
    else
    {
        return nil;
    }
    
}
@end
