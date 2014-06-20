//
//  MatrixMath.h
//  LineSum
//
//  Created by Lanston Peng on 5/7/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MatrixMath : NSObject

// init with array and size
- (id)initWithArray:(NSArray*)array andSize:(CGSize)size;

-(BOOL)isSumExist:(int)sum;

@property (strong, nonatomic) NSMutableArray* result;

@end
