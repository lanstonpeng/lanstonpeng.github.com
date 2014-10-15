//
//  LetterModel.h
//  MailCat
//
//  Created by Lanston Peng on 10/15/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LetterModel : NSObject

@property (strong,nonatomic)NSString* senderCity;
@property (strong,nonatomic)NSString* sendToEmail;
@property (strong,nonatomic)NSString* receiverCity;
@property (strong,nonatomic)NSString* receiverName;
@property (strong,nonatomic)NSString* letterBody;
@end
