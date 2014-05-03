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
#import "UserInfo.h"
//#import "MessageLogic.h"

static AppData *appData;

@implementation AppData

@synthesize timeline = _timeline;

- (id)init {
    if (self = [super init]) {
        [self loadMessageInPage:0];
//        self.userInfos = [[NSMutableDictionary alloc] init];
        _userInfos = [[NSMutableDictionary alloc] init];
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

- (void)loadMessageInPage:(int)page {
    NSArray *messages = [DataManager messagesInPage:page];
    _messages = [[NSMutableDictionary alloc] init];
    for (Message *message in messages) {
        if ([_messages objectForKey:message.mid])
            [DataManager deleteEntity:[_messages objectForKey:message.mid]];
        [_messages setObject:message forKey:message.mid];
    }
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

- (NSArray *)messagesNeedDownload {
    return [self messagesNeedDownloadFromIndex:0];
}

- (NSArray *)messagesNeedDownloadFromIndex:(int)index {
    [self loadMessageInPage:index / PAGE_MESSAGE_COUNT + 1];
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

- (UserInfo *)userInfoForId:(int)uid {
    NSNumber *uid0 = [NSNumber numberWithInt:uid];
    UserInfo *userInfo = [_userInfos objectForKey:uid0];
    if (userInfo) return userInfo;
    userInfo = [DataManager getUserInfo];
    [_userInfos setObject:userInfo forKey:uid0];
    userInfo.uid = uid0;
    return userInfo;
}

- (UserInfo *)readUserInfoForId:(int)uid {
    NSNumber *uid0 = [NSNumber numberWithInt:uid];
    UserInfo *userInfo = [_userInfos objectForKey:uid0];
    if (userInfo) return userInfo;
    userInfo = [DataManager getUserInfoOfUid:uid];
    if (!userInfo) return nil;
    [_userInfos setObject:userInfo forKey:uid0];
    return userInfo;
}

- (NSArray *)userInfosNeedDownload:(NSArray *)uids {
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    for (NSNumber *uid in uids) {
        if ([self readUserInfoForId:[uid intValue]]) continue;
        [ret addObject:uid];
    }
    return ret;
}

//- (UserInfo *)getUserInfo:(int)uid {
//    
//}

@end
