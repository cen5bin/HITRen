//
//  MessageLogic.m
//  Test
//
//  Created by wubincen on 14-1-1.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "MessageLogic.h"
#import "LogKit.h"
#import "HttpData.h"
#import "HttpTransfer.h"
#import "Timeline.h"

@implementation MessageLogic

+ (BOOL)sendShortMessage:(NSString *)message {
    FUNC_START();
    BOOL ret = [MessageLogic sendShortMessage:message toGroups:nil];
    FUNC_END();
    return ret;
}

+ (BOOL)sendShortMessage:(NSString *)message toGroup:(NSString *)gname {
    FUNC_START();
    BOOL ret = [MessageLogic sendShortMessage:message toGroups:[NSArray arrayWithObjects:gname, nil]];
    FUNC_END();
    return ret;
}

+ (BOOL)sendShortMessage:(NSString *)message toGroups:(NSArray *)gnames {
    FUNC_START();
    HttpData *data = [HttpData data];
    User *user = [MessageLogic user];
    [data setIntValue:user.uid forKey:@"uid"];
    [data setValue:message forKey:@"message"];
    if (!gnames) [data setIntValue:0 forKey:@"auth"];
    else {
        [data setIntValue:1 forKey:@"auth"];
        [data setValue:gnames forKey:@"gnames"];
    }
    
    L([gnames description]);
    BOOL ret = [[HttpTransfer transfer] asyncPost:[data getJsonString] to:@"SendShortMessage" withEventName:ASYNC_EVENT_SENDSHORTMESSAGE];
    if (!ret) {
        LOG(@"SendShortMessage fail");
        FUNC_END();
        return NO;
    }
    LOG(@"SendShortMessage succ");
    FUNC_END();
    return YES;
}

+ (BOOL)downloadTimeline {
    FUNC_START();
    HttpData *data = [HttpData data];
    User *user = [MessageLogic user];
//    [data setIntValue:user.uid forKey:@"uid"];
    [data setIntValue:user.timeline.seq forKey:@"seq"];
    BOOL ret = [[HttpTransfer transfer] asyncPost:[data getJsonString] to:@"DownloadTimeline" withEventName:ASYNC_EVENT_DOWNLOADTIMELINE];
    if (!ret) {
        L(@"DownloadTimeline failed");
        FUNC_END();
        return NO;
    }
    FUNC_END();
    return YES;
}

@end
