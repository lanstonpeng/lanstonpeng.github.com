//
//  ScoreView.h
//  LineSum
//
//  Created by Lanston Peng on 4/18/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ScoreLESS = 0,
    ScoreEQUAL,
    ScoreBIGGER
}ScoreState;

@protocol ScoreTargetDelgate <NSObject>

@optional
-(void)onScoreLess;
-(void)onScoreEqual;
-(void)onScoreBigger;
@end



@interface ScoreBoardView : UIView
@property (nonatomic)int targetSum;
@property (strong,nonatomic)UILabel* scoreLabel;
-(instancetype)initScoreBoradView:(int)targetSum withDelegate:(id<ScoreTargetDelgate>)delegate;
-(void)addNum:(NSUInteger)num;
-(void)minusNum:(NSUInteger)num;
-(void)resetNum;
-(ScoreState)getCurrentState;
@end
