//
//  PoemLineView.m
//  Poem
//
//  Created by Lanston Peng on 6/5/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "PoemLineView.h"

@implementation PoemLineView

- (id)initWithFrame:(CGRect)frame withData:(NSMutableAttributedString *)attributeString
{
    self = [super initWithFrame:frame];
    if (self) {
        self.attributedText = attributeString;
    }
    return self;
}
- (BOOL)canBecomeFirstResponder
{
    return NO;
}
@end
