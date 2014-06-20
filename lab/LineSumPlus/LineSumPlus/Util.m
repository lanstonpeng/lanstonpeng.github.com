//
//  Util.m
//  LineSum
//
//  Created by Lanston Peng on 4/17/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "Util.h"

@implementation Util
+ (NSDictionary*)generateNumbers:(NSUInteger)count{
    NSDictionary* dic = [[NSDictionary alloc]init];
    NSMutableArray* result = [[NSMutableArray alloc]init];
    NSMutableArray* candidate = [[NSMutableArray alloc]initWithArray:@[@1,@2,@3,@4,@5,@6,@7,@8,@9]];
    int sum = 0;
    while (count) {
        int idx = arc4random()% [candidate count];
        [result addObject:candidate[idx]];
        sum += [candidate[idx] integerValue];
        [candidate removeObject:candidate[idx]];
        candidate = [Util shrinkArray:candidate];
        count--;
    }
    dic = @{
            @"sequence":result,
            @"sum":[NSNumber numberWithInt:sum]
            };
    return dic;
}
+ (NSMutableArray*)shrinkArray:(NSMutableArray*)origin{
    NSMutableArray* target = [[NSMutableArray alloc]init];
    int i = 0;
    for(;i < [origin count];i++){
        if(origin[i]){
            [target addObject:origin[i]];
        }
    }
    return target;
}
+(UIColor*)generateColor{
    switch (arc4random()%6) {
        case 0: return UIColorFromRGB(0x50ecb3);
        case 1: return UIColorFromRGB(0xb350ec);
        case 2: return UIColorFromRGB(0x50ec65);
        case 3: return UIColorFromRGB(0xecb350);
        case 4: return UIColorFromRGB(0xec5089);
        case 5: return UIColorFromRGB(0x50d7ec);
    }
    return UIColorFromRGB(0xec5089);
}
+ (UIColor*)generateColorWithNum:(NSString*)valString{
    int value = [valString intValue];
    switch (value) {
        case 1:{
            return UIColorFromRGB(0xE0E4CC);
        }
        case 2:{
            return UIColorFromRGB(0xC8CBB6);
        }
        case 3:{
            return UIColorFromRGB(0xA7DBD8);
        }
        case 4:{
            return UIColorFromRGB(0x95C3C1);
        }
        case 5:{
            return UIColorFromRGB(0x69D2E7);
        }
        case 6:{
            return UIColorFromRGB(0x5DBBCE);
        }
        case 7:{
            return UIColorFromRGB(0xF38630);
        }
        case 8:{
            return UIColorFromRGB(0xD9772A);
        }
        case 9:{
            return UIColorFromRGB(0xFA6900);
        }
        default:{
            return UIColorFromRGB(0xDF5D00);
        }
    }
}
@end
