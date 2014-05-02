//
//  AppData.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-2.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Timeline, Message;
@interface AppData : NSObject {
    Timeline *_timeline;
    NSMutableDictionary *_messages;
    NSMutableArray *_messageList;
}

@property (nonatomic, strong, getter = getTimeline) Timeline *timeline;
@property (nonatomic, strong, getter = getMessageList) NSMutableArray *messageList;

+ (id)sharedInstance;
+ (void)saveData;

+ (Message *)newMessage;
- (id)init;
- (Message *)messgeForId:(int)mid;
- (NSArray *)messagesNeedDownload;
- (NSArray *)messagesNeedDownloadFromIndex:(int)index;
- (NSArray *)getMessagesInPage:(int)page;

//- (void)insertMessage:(Message *)message;
@end
