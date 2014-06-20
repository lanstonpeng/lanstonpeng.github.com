//
//  CubeContainerView.m
//  LineSum
//
//  Created by Lanston Peng on 4/20/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "CubeContainerView.h"

//container with GRID_WIDTH * GRID_HEIGHT cubes
#define GRID_WIDTH 4
#define GRID_HEIGHT 4

#define UP_PADDING 10

//The width of cube
#define CUBE_WIDTH 80

// 320 / CUBE_WIDTH
#define CUBE_LINE_COUNT 4

//the "offically" number of solution
#define CUBE_COUNT 3

//Game Cube Value
#define CUBE_VALUE_MAX 9
#define CUBE_SELECTED_COLOR 0xFF6B6B

@interface CubeContainerView()


@property  (strong,nonatomic)UIPanGestureRecognizer* containerPanGesture;

@property  (strong,nonatomic)UITapGestureRecognizer* containerTapGesture;

//An array that record the path of the pan gesture
@property (strong,nonatomic)CubePath* cubePath;

//For providing hints
@property (strong,nonatomic)NSMutableArray* solutionIdxArray;

//a reference of the hint view
@property (strong,nonatomic)UIView* hintViewRef;

//For placing the solution path
@property (strong,nonatomic)NSMutableArray* occupiedArray;

//The solution sequence
@property (strong,nonatomic)NSArray* solutionSequence;
@property (nonatomic)NSUInteger sum;

//well ,this is the ugly stuff, cubeContainerView is tied to scoreBoardView
@property (strong,nonatomic)ScoreBoardView* scoreBoardView;

@end

@implementation CubeContainerView

- (NSMutableArray *)solutionIdxArray{
    if(!_solutionIdxArray){
        _solutionIdxArray = [[NSMutableArray alloc]init];
    }
    return  _solutionIdxArray;
}
- (NSMutableArray *)occupiedArray{
    if(!_occupiedArray){
        _occupiedArray = [[NSMutableArray alloc]init];
    }
    return _occupiedArray;
}
-(CubePath*)cubePath{
    if(!_cubePath){
        _cubePath = [[CubePath alloc]init];
    }
    return _cubePath;
}
//put the solution path in the container view
- (void)lineUpSolutionPath:(NSArray*)sequence
{
    int x = arc4random() % 4;
    int y = arc4random() % 4;
    BOOL hasChanged = NO;
    NSMutableArray* avaiable = [[NSMutableArray alloc]initWithArray:@[@0,@1,@2,@3]];
    NSNumber* deprecated = @-1;
    for(int i = 0;i < [sequence count];i++){
        hasChanged = NO;
        int directionIdx = arc4random() % [avaiable count];
        switch ([avaiable[directionIdx]intValue]) {
            //UP
            case 0:{
                y--;
                hasChanged = YES;
                if(![self isValidCoordinate:x y:y])
                {
                    y++;
                    i--;
                    hasChanged = NO;
                }
                break;
            }
            //DOWN
            case 1:{
                y++;
                hasChanged = YES;
                if(![self isValidCoordinate:x y:y])
                {
                    y--;
                    i--;
                    hasChanged = NO;
                }
                break;
            }
            //RIGHT
            case 2:{
                x++;
                hasChanged = YES;
                if(![self isValidCoordinate:x y:y])
                {
                    x--;
                    i--;
                    hasChanged = NO;
                }
                break;
            }
            //LEFT
            case 3:{
                x--;
                hasChanged = YES;
                if(![self isValidCoordinate:x y:y])
                {
                    x++;
                    i--;
                    hasChanged = NO;
                }
                break;
            }
            default:
                break;
        }
        if(hasChanged){
            if([deprecated intValue] > -1){
                [avaiable addObject:deprecated];
            }
            deprecated = avaiable[directionIdx];
            [avaiable removeObject:avaiable[directionIdx]];
            [self.occupiedArray addObject:@[[NSNumber numberWithInt:x],[NSNumber numberWithInt:y]]];
            [self placeAValideCubeView:x y:y withSequenceIdx:i];
        }
    }
}

//actually the a valide cube in the given coordinate
- (void)placeAValideCubeView:(int)x y:(int)y withSequenceIdx:(NSUInteger)index
{
    int idx = [self getIndex:x y:y];
    UIView* currentView =[self viewWithTag:idx];
    UILabel* numLabel = (UILabel*)[currentView viewWithTag:LUCKY_NUM];
    NSNumber* number = self.solutionSequence[index];
    [self.solutionIdxArray addObject:[NSNumber numberWithInt:idx]];
    currentView.backgroundColor = [Util generateColorWithNum:[number stringValue]];
    numLabel.attributedText = [self generateLabelAttributeString:[number stringValue]];
}

- (NSMutableAttributedString*)generateLabelAttributeString:(NSString*)content{
    NSMutableAttributedString* labelAttributeString = [[NSMutableAttributedString alloc]initWithString:content];
    NSRange range = NSMakeRange(0, content.length);
    [labelAttributeString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Apple Color Emoji" size:36] range:range];
    [labelAttributeString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:range];
    return labelAttributeString;
}


- (UIView*)generateCube:(CGRect)frame withNum:(int)currentNum{
    UIView* cubeView = [[UIView alloc]initWithFrame:frame];
    [cubeView setBackgroundColor:[Util generateColorWithNum:[NSString stringWithFormat:@"%d",currentNum]]];
    
    UILabel* numLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,CUBE_WIDTH, CUBE_WIDTH)];
    numLabel.attributedText = [self generateLabelAttributeString:[NSString stringWithFormat:@"%d",currentNum]];
    numLabel.textAlignment = NSTextAlignmentCenter;
    
    [numLabel setTag:LUCKY_NUM];
    [cubeView addSubview:numLabel];
    return cubeView;
}
//generate the container
- (void)generateGrid:(NSArray*)sequence{
    int i = 0;
    int randomNumber;
    for(;i< GRID_WIDTH * GRID_HEIGHT; i++){
        randomNumber = arc4random() % (CUBE_VALUE_MAX - 1) + 1;
        UIView* cubeView =[self generateCube:CGRectMake( i * CUBE_WIDTH % (int)IPHONE_SCREEN_WIDTH, UP_PADDING + (i / CUBE_LINE_COUNT) * CUBE_WIDTH, CUBE_WIDTH, CUBE_WIDTH) withNum:randomNumber];
        [cubeView setTag:i+1];
        [self addSubview:cubeView];
    }
}
//get the index of the array while paning in the container
- (int)getIndex:(int)x y:(int)y
{
    return x + y * GRID_WIDTH + 1;
}

//check if the input coordinate is valid
//  is inside the boundary
//  is not occupied
- (BOOL)isValidCoordinate:(int)x y:(int)y
{
    int boundaryX = GRID_WIDTH - 1;
    int boundaryY = GRID_HEIGHT - 1;
    return (x >= 0 && y>=0 && x<= boundaryX && y<=boundaryY) && ![self isOccupied:x y:y];
}

//Test if the input coordinate has been occupied
- (BOOL)isOccupied:(int)x y:(int)y
{
    for(int i = 0 ;i < [self.occupiedArray count]; i++)
    {
        if([self.occupiedArray[i][0] intValue] == x &&[self.occupiedArray[i][1] intValue] == y)
        {
            return YES;
        }
    }
    return NO;
}

//while the user pan too fast on diagonal line ,it would properly cause bug
- (BOOL)isDiagonalLine:(int)x2 y:(int)y2{
    CubeEntity* lastObject = [self.cubePath.cubePathArray lastObject];
    if(!lastObject){
        return NO;
    }
    int y1 = [lastObject.y intValue];
    int x1 = [lastObject.x intValue];
    if(y1 == y2){
        if(x1 == x2 - 1 || x1 == x2 + 1){
            return NO;
        }
    }
    else if(x1 == x2){
        if(y1 == y2 -1 || y1 == y2 + 1){
            return NO;
        }
    }
    return YES;
}

#pragma handle Tap gesture
-(void)handleCubeTap:(UITapGestureRecognizer*)sender{
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self];
    self.hasTapOnContainer = YES;
    self.gameState = GameInit;
    double pointerX = pt.x;
    double pointerY = pt.y;
    
    int x =  pointerX / (GRID_WIDTH * CUBE_WIDTH ) * GRID_WIDTH;
    int y = pointerY / (GRID_HEIGHT * CUBE_WIDTH) * GRID_HEIGHT;
    int idx =(x+ 4 * y + 1);
    
    UIView* currentView =[self viewWithTag:idx];
    [currentView setBackgroundColor:UIColorFromRGB(CUBE_SELECTED_COLOR)];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(self.hasTapOnContainer == YES){
        UITouch* touch = [touches anyObject];
        CGPoint pt = [touch locationInView:self];
        
        double pointerX = pt.x;
        double pointerY = pt.y;
        
        int x =  pointerX / (GRID_WIDTH * CUBE_WIDTH ) * GRID_WIDTH;
        int y = pointerY / (GRID_HEIGHT * CUBE_WIDTH) * GRID_HEIGHT;
        int idx =(x + 4 * y + 1);
        UIView* currentView =[self viewWithTag:idx];
        UILabel* numLabel = (UILabel*)[currentView viewWithTag:LUCKY_NUM];
        [currentView setBackgroundColor:[Util generateColorWithNum:numLabel.text]];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

#pragma handle Pan gesture
-(void)handleCubePan:(UIPanGestureRecognizer *)sender
{
    if(self.gameState == GameRevertCauseBigger){
        return;
    }
    if(!self.hasTapOnContainer){
        self.hasTapOnContainer = YES;
        [self stopBlink];
    }
    double pointerX = [sender locationInView:self].x;
    double pointerY = [sender locationInView:self].y - UP_PADDING;
    
    int x =  pointerX / (GRID_WIDTH * CUBE_WIDTH ) * GRID_WIDTH;
    int y = pointerY / (GRID_HEIGHT * CUBE_WIDTH) * GRID_HEIGHT;
    
    int idx =(x+ 4 * y + 1);
    UIView* currentView =[self viewWithTag:idx];
    CubeEntity* cubeEntity = [[CubeEntity alloc]initWithView:currentView x:x y:y];
    
    //TODO: record the cube path so that we can change the status while users moving back while it move inside the cube ,prevent it from running the logic again the first time moving into the current view
    if(![self.cubePath isEqualToLastObject:cubeEntity]){
        
        //prevent diagonal line
        if([self isDiagonalLine:x y:y]){
            return;
        }
        int num = [cubeEntity.score intValue];
        if(![self.cubePath containCubePath:cubeEntity]){
            [cubeEntity.cubeView setBackgroundColor:UIColorFromRGB(CUBE_SELECTED_COLOR)];
            [self.cubePath addCubeEntity:cubeEntity];
            [self.scoreBoardView addNum:num];
        }
        //if the view is already in the path,we revert the path
        else{
            [self revertPathFrom:cubeEntity];
        }
    }
    else if(sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled){
        if([self.scoreBoardView getCurrentState] != ScoreEQUAL){
            [self revertAllCubePath];
        }
        if([self.scoreBoardView getCurrentState] == ScoreLESS){
            if([self.delegate respondsToSelector:@selector(onCubeContainerPanGestureEndWithLessScore)]){
                [self.delegate performSelector:@selector(onCubeContainerPanGestureEndWithLessScore) withObject:nil];
            }
        }
    }
    
}


#pragma other
- (void)giveAHint{
    if([self.solutionIdxArray count] < 1){
        return;
    }
    
    int idx = [(NSNumber*)[self.solutionIdxArray firstObject] intValue];
    self.hintViewRef =[self viewWithTag:idx];
    
    self.hintViewRef.alpha = 1.0f;
    [UIView animateWithDuration:0.6
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut |
     UIViewAnimationOptionRepeat |
     UIViewAnimationOptionAutoreverse |
     UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.hintViewRef.alpha = 0.3f;
                     }
                     completion:^(BOOL finished){
                         // Do nothing
                     }];
}
-(void)stopBlink{
    [UIView animateWithDuration:0.12
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut |
     UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.hintViewRef.alpha = 1.0f;
                     }
                     completion:^(BOOL finished){
                         // Do nothing
                     }];

}


- (void)revertAllCubePath{
    CubeEntity* firstEntity = [self.cubePath.cubePathArray firstObject];
    [self revertPathFrom:firstEntity];
    self.gameState = GameRevertCauseBigger;
}
- (void)revertPathFrom:(CubeEntity*)cubeEntity
{
    __weak typeof(self) weakSelf = self;
   [_cubePath revertPathAfterCubeView:cubeEntity executeBlokOnRevertedItem:^(CubeEntity *cubeEntity) {
       [cubeEntity.cubeView setBackgroundColor:[Util generateColorWithNum:cubeEntity.score]];
       [weakSelf.scoreBoardView minusNum:[cubeEntity.score intValue]];
   } includingBeginItem:YES];
}

- (void)resetParameter{
       //removing the occuiped solution array idx for placing the new
       [self.occupiedArray removeAllObjects];
       [self.cubePath.cubePathArray removeAllObjects];
       [self.solutionIdxArray removeAllObjects];
       self.hasTapOnContainer = NO;
}
#pragma init stuffs
- (id)initWithFrame:(CGRect)frame withSolutionDic:(NSDictionary*)dic andScoreView:(ScoreBoardView*)scoreBoardView{
    if(self = [super initWithFrame:frame])
    {
        self.solutionSequence = [dic objectForKey:@"sequence"];
        self.sum = [(NSNumber*)[dic objectForKey:@"sum"] integerValue];
        
        self.containerPanGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleCubePan:)];
        [self.containerPanGesture setMaximumNumberOfTouches:1];
        [self addGestureRecognizer:self.containerPanGesture];
        [self.containerPanGesture setCancelsTouchesInView:NO];
        /*
        self.containerTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleCubeTap:)];
        [self addGestureRecognizer:self.containerTapGesture];
         */
        [self resetParameter];
        [self generateGrid:self.solutionSequence];
        [self lineUpSolutionPath:self.solutionSequence];
        
        self.scoreBoardView = scoreBoardView;
        
        [self setMultipleTouchEnabled:NO];
    }
    return self;
}

@end
