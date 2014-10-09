//
//  PoemReader.h
//  Poem
//
//  Created by Lanston Peng on 6/2/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol PoemReaderDelegate <NSObject>

-(void)AllPoemDidDownload:(NSArray*)poemDataArr;

@end

@interface PoemReader : NSObject

@property (strong,nonatomic)id<PoemReaderDelegate> delegate;

@property (strong,nonatomic)NSArray* poemListDataArr;

+ (instancetype)sharedPoemReader;

-(NSArray*)getAllPoems;

-(NSDictionary*)getPoemByID;

-(void)getAllPoemsFromServer;

-(void)fetchNewData;
@end
