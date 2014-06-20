//
//  CubeContainerView.h
//  LineSum
//
//  Created by Lanston Peng on 4/20/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CubeEntity.h"
#import "CubePath.h"
#import "Util.h"
#import "ScoreBoardView.h"

typedef enum{
    GameInit = 0,
    GameRevertCauseBigger,
    GameRevertCauseSmaller,
    GameLoseCauseTimeout
}GameState;

@protocol CubeContainerDelegate <NSObject>

@optional
-(void)onCubeContainerPanGestureEndWithLessScore;
@end

@interface CubeContainerView : UIView

//literally
@property (nonatomic)BOOL hasTapOnContainer;

//Flag for contorlling the game
@property (nonatomic)GameState gameState;

@property (strong,nonatomic)id<CubeContainerDelegate> delegate;

- (id)initWithFrame:(CGRect)frame withSolutionDic:(NSDictionary*)dic andScoreView:(ScoreBoardView*)scoreBoardView;
- (void)giveAHint;
- (void)revertAllCubePath;
@end
