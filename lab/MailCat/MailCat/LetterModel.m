//
//  LetterModel.m
//  MailCat
//
//  Created by Lanston Peng on 10/15/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "LetterModel.h"

@interface LetterModel()<NSCopying>

@end
@implementation LetterModel

- (id)copyWithZone:(NSZone *)zone
{
    LetterModel* copyItem = [[[self class] allocWithZone:zone]init];
    if (copyItem) {
        copyItem.senderCity = self.senderCity;
        copyItem.sendToEmail = self.sendToEmail;
        copyItem.senderEmail = self.senderEmail;
        copyItem.receiverCity = self.receiverCity;
        copyItem.receiverName = self.receiverName;
        copyItem.letterBody = self.letterBody;
        copyItem.letterStatus = self.letterStatus;
        copyItem.sendDate = self.sendDate;
    }
    return copyItem;
}
@end
