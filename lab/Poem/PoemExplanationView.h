//
//  PoemExplanationView.h
//  Poem
//
//  Created by Lanston Peng on 6/4/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PoemExplanationView : UIView
@property (strong,nonatomic)NSString* explanationData;
- (id)initWithFrame:(CGRect)frame withExplanation:(NSString*)explanation;
@end
