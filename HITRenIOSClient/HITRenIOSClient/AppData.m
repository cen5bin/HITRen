//
//  AppData.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-2.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "AppData.h"
#import "DataManager.h"
#import "Timeline.h"
#import "Message.h"
//#import "MessageLogic.h"

static AppData *appData;

@implementation AppData

@synthesize timeline = _timeline;
@synthesize messageList = _messageList;

- (id)init {
    if (self = [super init]) {
        NSArray *messages = [DataManager messagesInPage:0];
        _messages = [[NSMutableDictionary alloc] init];
        for (Message *message in messages)
            [_messages setObject:message forKey:message.mid];
    }
    return self;
}

+ (id)sharedInstance {
    if (appData) return appData;
    appData = [[AppData alloc] init];
    return appData;
}

+ (void)saveData {
    [DataManager save];
}

+ (Message *)newMessage {
    return [DataManager getMessage];
}

- (Timeline*)getTimeline {
    if (_timeline) return _timeline;
    _timeline = [DataManager timeline];
    return _timeline;
}

- (Message *)messgeForId:(int)mid {
    NSNumber *mid0 = [NSNumber numberWithInt:mid];
    Message *message = [_messages objectForKey:mid0];
    if (message == nil) {
        message = [AppData newMessage];
        [_messages setObject:message forKey:mid0];
        message.mid = mid0;
    }
    return message;
}

- (Message *)privateMessageForId:(int)mid {
    NSNumber *mid0 = [NSNumber numberWithInt:mid];
    return [_messages objectForKey:mid0];
}

- (NSMutableArray *)getMessageList {
    if (_messageList) return _messageList;
    _messageList = [[NSMutableArray alloc] init];
    int count = self.timeline.mids.count;
    if (count > PAGE_MESSAGE_COUNT) count = PAGE_MESSAGE_COUNT;
    NSMutableArray *needDownload = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++) {
        Message *message = [self privateMessageForId:[[self.timeline.mids objectAtIndex:i] intValue]];
        if (!message)
            [needDownload addObject:[self.timeline.mids objectAtIndex:i]];
    }
    
    return _messageList;
}

- (NSArray *)messagesNeedDownload {
    return [self messagesNeedDownloadFromIndex:0];
//    NSMutableArray *ret = [[NSMutableArray alloc] init];
//    int count = self.timeline.mids.count;
//    if (count > PAGE_MESSAGE_COUNT) count = PAGE_MESSAGE_COUNT;
//    for (int i = 0; i < count; i++) {
//        if ([self privateMessageForId:[[self.timeline.mids objectAtIndex:i] intValue]]) break;
//        [ret addObject:[self.timeline.mids objectAtIndex:i]];
//    }
//    return ret;
}

- (NSArray *)messagesNeedDownloadFromIndex:(int)index {
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    int count = self.timeline.mids.count;
    if (index >= count) return nil;
    int count0 = count;
    if (count0 > PAGE_MESSAGE_COUNT) count0 = PAGE_MESSAGE_COUNT;
    for (int i = 0; i < count0 && i + index < count ; i++) {
        if ([self privateMessageForId:[[self.timeline.mids objectAtIndex:i + index] intValue]]) break;
        [ret addObject:[self.timeline.mids objectAtIndex:i + index]];
    }
    return ret;
}

- (NSArray *)getMessagesInPage:(int)page {
    return [DataManager messagesInPage:page];
}
//- (void)insertMessage:(Message *)message {
//    Message *tmp = [self messgeForId:message.mid];
//    if (tmp == nil) {
//        tmp = [DataManager getMessage];
//        [_messages setObject:tmp forKey:message.mid];
//    }
//    tmp.mid = message.mid;
//    tmp.content = message.content;
//    tmp.type = message.type;
//    tmp.likedlist = message.likedlist;
//    tmp.uid = message.uid;
//    tmp.time = message.time;
//    tmp.sharedCount = message.sharedCount;
//    tmp.comment = message.comment;
//}
@end
