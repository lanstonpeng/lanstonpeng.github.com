//
//  MatrixMath.m
//  LineSum
//
//  Created by Lanston Peng on 5/7/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "MatrixMath.h"

#define RIGHT 1
#define DOWN 2

@interface MatrixMath()
@property (nonatomic) int sum;
@property (strong, nonatomic) NSArray* matrix;
@property (nonatomic) CGSize size;
@property (strong,nonatomic)NSMutableArray* stack;
@property (nonatomic) BOOL found;
@end

@implementation MatrixMath

- (id)initWithArray:(NSArray*)array andSize:(CGSize)size {
    if (self = [super init]) {
        _matrix = array;
        _size = size;
        _stack = [[NSMutableArray alloc]init];
        _result = [NSMutableArray new];
    }
    return self;
}

-(BOOL)isSumExist:(int)sum
{
    _sum =sum;
    for (int i = 0; i < _size.height; i++) {
        for (int j = 0; j < _size.width; j++) {
            [self dfs4:0 withX:i withY:j];
            if (_found) {
                return YES;
            }
        }
    }
    return NO;
}

-(void)printResult:(NSArray*)result
{
    for(int i = 0 ;i < [result count] ; i++) {
        int index = [result[i] intValue];
        int posx = index/(_size.width-0.5);
        int posy = index%(int)_size.width;
    }
}
/**
 *  DFS for 4 directions
 *
 *  @param sum current sum of numberes
 *  @param x   literally
 *  @param y   literally
 *
 *  @return flag(not used here)
 */
-(int)dfs4:(int)sum withX:(int)x withY:(int)y{
    int index = x*_size.width + y;
    int currentNum = [_matrix[index] intValue];
    if([_stack containsObject:@(index)]){
        return -1;
    }
    sum = currentNum + sum;
    if(sum == _sum){
        [_stack addObject:@(index)];
        [self printResult:_stack];
        [_result addObject:[_stack copy]];
        _found = YES;
        return 1;
    }
    [_stack addObject:@(index)];
    if(sum > _sum){
        [_stack removeObject:[_stack lastObject]];
        return -1;
    }
    //right
    if( ++y < (int)_size.width){
        [self dfs4:sum withX:x withY:y];
    }
    y--;
    //down
    if( ++x < (int)_size.height){
        [self dfs4:sum withX:x withY:y];
    }
    x--;
    
    //left
    if(--y >= 0){
        [self dfs4:sum withX:x withY:y];
    }
    y++;
    
    //up
    if(--x >= 0 ){
        [self dfs4:sum withX:x withY:y];
    }
    x++;
    [_stack removeObject:[_stack lastObject]];
    return -1;
}

@end