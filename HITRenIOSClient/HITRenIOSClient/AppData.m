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

static AppData *appData;

@implementation AppData

@synthesize timeline = _timeline;

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

- (Message *)messgeForId:(NSNumber *)mid {
    return [_messages objectForKey:mid];
}

- (void)insertMessage:(Message *)message {
    Message *tmp = [self messgeForId:message.mid];
    if (tmp == nil) {
        tmp = [DataManager getMessage];
        [_messages setObject:tmp forKey:message.mid];
    }
    tmp.mid = message.mid;
    tmp.content = message.content;
    tmp.type = message.type;
    tmp.likedlist = message.likedlist;
    tmp.uid = message.uid;
    tmp.time = message.time;
    tmp.sharedCount = message.sharedCount;
    tmp.comment = message.comment;
}
@end
