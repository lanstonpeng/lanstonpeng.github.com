//
//  LetterModel.h
//  MailCat
//
//  Created by Lanston Peng on 10/15/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum
{
    Draft = 1,
    Pending,
    Sent,
    Received,
    HasRead
}LetterStatus;

@interface LetterModel : NSObject

@property (strong,nonatomic)NSString* senderCity;
@property (strong,nonatomic)NSString* sendToEmail;
@property (strong,nonatomic)NSString* senderEmail;
@property (strong,nonatomic)NSString* receiverCity;
@property (strong,nonatomic)NSString* receiverName;
@property (strong,nonatomic)NSString* letterBody;
@property (strong,nonatomic)NSDate*   receiveDate;
@property (strong,nonatomic)NSDate*   sendDate;
@property (nonatomic)LetterStatus letterStatus;

- (instancetype)initWithDic:(NSDictionary*)dic;
@end
