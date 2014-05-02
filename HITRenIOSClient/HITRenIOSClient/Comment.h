//
//  Comment.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-2.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Message;

@interface Comment : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSNumber * reuid;
@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) Message *messageInfo;

@end
