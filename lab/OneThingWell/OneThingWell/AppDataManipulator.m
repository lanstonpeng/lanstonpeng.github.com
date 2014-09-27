//
//  AppDataManipulator.m
//  OneThingWell
//
//  Created by Lanston Peng on 9/25/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "AppDataManipulator.h"

@interface AppDataManipulator() 

@property (strong,nonatomic)NSMutableArray* favAppArray;

@end

@implementation AppDataManipulator

+ (instancetype)singleton{
    
    static dispatch_once_t token;
    static AppDataManipulator* dataManipulator;
    
    dispatch_once(&token, ^{
        dataManipulator = [AppDataManipulator new];
        dataManipulator.favAppArray =[[NSMutableArray alloc]initWithArray:[dataManipulator fetchAllSavedItem]];
        NSLog(@"%@",dataManipulator.favAppArray);
    });
    
    return dataManipulator;
}

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
        //create empty file
        //[fileManager createFileAtPath:fullPath contents:[NSData data] attributes:nil];
        return @[];
    }
    
}

- (void)updateAnItem:(OneThingModel*)model{
    [self.favAppArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        OneThingModel* item = (OneThingModel*)obj;
        if ([item.appID isEqualToString:model.appID]) {
            obj = [model copy];
            NSLog(@"updated An Item %@",obj);
            [self flushDataToFile];
            *stop = YES;
        }
    }];
}

- (void)addAnItem:(OneThingModel*)model{
    __block BOOL isDuplicated = NO;
    [self.favAppArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        OneThingModel* item = (OneThingModel*)obj;
        if ([item.appID isEqualToString:model.appID]) {
            isDuplicated = YES;
            *stop = YES;
        }
    }];
    
    if (!isDuplicated) {
        [self.favAppArray addObject:model];
        [self flushDataToFile];
    }
}

- (void)deleteAnItem:(OneThingModel*)model{
    [self.favAppArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        OneThingModel* item = (OneThingModel*)obj;
        if ([item.appID isEqualToString:model.appID]) {
            [self.favAppArray removeObject:item];
            [self flushDataToFile];
            *stop = YES;
        }
    }];
}
- (void)flushDataToFile{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:@"fav_app.dat"];
    NSData* modelData = [NSKeyedArchiver archivedDataWithRootObject:self.favAppArray];
    [fileManager createFileAtPath:fullPath contents:modelData attributes:nil];
}

- (BOOL)isInLocalFav:(NSString*)appID{
    __block BOOL isDuplicated = NO;
    [self.favAppArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        OneThingModel* item = (OneThingModel*)obj;
        if ([item.appID isEqualToString:appID]) {
            isDuplicated = YES;
            *stop = YES;
        }
    }];
    return isDuplicated;
}

@end
