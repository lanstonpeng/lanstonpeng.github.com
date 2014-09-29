//
//  OneThingModel.m
//  OneThingWell
//
//  Created by Lanston Peng on 9/24/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "OneThingModel.h"

@interface OneThingModel()<NSCoding,NSCopying>

@end
@implementation OneThingModel

- (id)copyWithZone:(NSZone *)zone
{
    OneThingModel* copyItem = [[[self class] allocWithZone:zone]init];
    if (copyItem) {
        copyItem.appName = self.appName;
        copyItem.appDescription = self.appDescription;
        copyItem.appURL = self.appURL;
        copyItem.screenShoot = self.screenShoot;
        copyItem.pubTimeStr = self.pubTimeStr;
        copyItem.tags = self.tags;
        copyItem.appID = self.appID;
        copyItem.isFav = self.isFav;
        copyItem.websiteContent = self.websiteContent;
    }
    return copyItem;
}
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.appName forKey:@"appName"];
    [aCoder encodeObject:self.appDescription forKey:@"appDescription"];
    [aCoder encodeObject:self.appURL forKey:@"appURL"];
    [aCoder encodeObject:self.screenShoot forKey:@"screenShoot"];
    [aCoder encodeObject:self.pubTimeStr forKey:@"pubTimeStr"];
    [aCoder encodeObject:self.tags forKey:@"tags"];
    [aCoder encodeObject:self.appID forKey:@"appID"];
    [aCoder encodeObject:self.websiteContent forKey:@"websiteContent"];
    [aCoder encodeBool:self.isFav forKey:@"isFav"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.appName = [aDecoder decodeObjectForKey:@"appName"];
        self.appDescription = [aDecoder decodeObjectForKey:@"appURL"];
        self.appURL = [aDecoder decodeObjectForKey:@"appURL"];
        self.screenShoot = [aDecoder decodeObjectForKey:@"screenShoot"];
        self.pubTimeStr = [aDecoder decodeObjectForKey:@"pubTimeStr"];
        self.tags = [aDecoder decodeObjectForKey:@"tags"];
        self.appID = [aDecoder decodeObjectForKey:@"appID"];
        self.websiteContent = [aDecoder decodeObjectForKey:@"websiteContent"];
        self.isFav = [aDecoder decodeBoolForKey:@"isFav"];
    }
    return self;
}
@end
