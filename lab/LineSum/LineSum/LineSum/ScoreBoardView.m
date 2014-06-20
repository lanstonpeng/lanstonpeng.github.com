//
//  ScoreView.m
//  LineSum
//
//  Created by Lanston Peng on 4/18/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "ScoreBoardView.h"

@interface ScoreBoardView()
@property (strong,nonatomic)id<ScoreTargetDelgate> delegate;
@property  (nonatomic)ScoreState scoreState;
@end

@implementation ScoreBoardView

-(instancetype)initScoreBoradView:(int)targetSum withDelegate:(id)delegate{
    if(self = [super init]){
        self.frame = CGRectMake(50, 50, 50, 40);
        self.scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 50, 40)];
        self.scoreLabel.text = [NSString stringWithFormat:@"%d",0];
        [self addSubview:self.scoreLabel];
        self.targetSum = (int)targetSum;
        self.delegate = delegate;
        self.scoreState = ScoreLESS;
    }
    return self;
}
-(void)addNum:(NSUInteger)num{
    int updateScore =[self.scoreLabel.text intValue] +(int)num;
    if (updateScore == self.targetSum) {
        if([self.delegate respondsToSelector:@selector(onScoreEqual)]){
            self.scoreState = ScoreEQUAL;
            [self.delegate onScoreEqual];
        }
    }
    else if(updateScore > self.targetSum){
        if([self.delegate respondsToSelector:@selector(onScoreBigger)]){
            self.scoreState = ScoreBIGGER;
            [self.delegate onScoreBigger];
        }
    }
    else{
        if([self.delegate respondsToSelector:@selector(onScoreLess)]){
            self.scoreState = ScoreLESS;
            [self.delegate onScoreLess];
        }
        self.scoreLabel.text = [NSString stringWithFormat:@"%d",updateScore];
    }
}
-(void)minusNum:(NSUInteger)num{
    int updateScore =[self.scoreLabel.text intValue] - (int)num;
    self.scoreLabel.text = [NSString stringWithFormat:@"%d",updateScore];
}
-(void)resetNum{
    self.scoreLabel.text = @"0";
    self.scoreState = ScoreLESS;
}
-(ScoreState)getCurrentState{
    return self.scoreState;
}

@end
