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
#import "DataManager.h"
#import "AppData.h"

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
//    User *user = [MessageLogic user];
//    [data setIntValue:user.uid forKey:@"uid"];
    [data setIntValue:[DataManager timeline].seq.intValue forKey:@"seq"];
    BOOL ret = [[HttpTransfer transfer] asyncPost:[data getJsonString] to:@"DownloadTimeline" withEventName:ASYNC_EVENT_DOWNLOADTIMELINE];
    if (!ret) {
        L(@"DownloadTimeline failed");
        FUNC_END();
        return NO;
    }
    FUNC_END();
    return YES;
}

+ (BOOL)downloadMessages:(NSArray *)mids {
    FUNC_START();
    HttpData *data = [HttpData data];
    [data setValue:mids forKey:@"mids"];
    BOOL ret = [[HttpTransfer transfer] asyncPost:[data getJsonString] to:@"DownloadMessages" withEventName:ASYNC_EVENT_DOWNLOADMESSAGES];
    if (!ret) {
        L(@"DownloadMessages failed");
        FUNC_END();
        return NO;
    }
    FUNC_END();
    return YES;
}

+ (BOOL)likeMessage:(int)mid {
    FUNC_START();
    HttpData *data = [HttpData data];
    User *user = [MessageLogic user];
    [data setIntValue:mid forKey:@"mid"];
    [data setIntValue:user.uid forKey:@"uid"];
    BOOL ret = [[HttpTransfer transfer] asyncPost:[data getJsonString] to:@"LikeTheMessage" withEventName:ASYNC_EVENT_LIKEMESSAGE];
    if (!ret) {
        L(@"LikeMessage failed");
        FUNC_END();
        return NO;
    }
    FUNC_END();
    return YES;
}

+ (BOOL)dislikeMessage:(int)mid {
    FUNC_START();
    HttpData *data = [HttpData data];
    User *user = [MessageLogic user];
    [data setIntValue:mid forKey:@"mid"];
    [data setIntValue:user.uid forKey:@"uid"];
    BOOL ret = [[HttpTransfer transfer] asyncPost:[data getJsonString] to:@"CancelLikeTheMessage" withEventName:ASYNC_EVENT_LIKEMESSAGE];
    if (!ret) {
        L(@"CancelLikeMessage failed");
        FUNC_END();
        return NO;
    }
    FUNC_END();
    return YES;
}

+ (BOOL)downloadLikedList:(NSArray *)mids {
    FUNC_START();
    HttpData *data = [HttpData data];
    AppData *appData = [AppData sharedInstance];
    [data setValue:[appData likedListNeedDownload:mids] forKey:@"datas"];
    BOOL ret = [[HttpTransfer transfer] asyncPost:[data getJsonString] to:@"DownloadLikedList" withEventName:ASYNC_EVENT_DOWNLOADLIKEDLIST];
    if (!ret) {
        L(@"DownloadLikedList failed");
        FUNC_END();
        return NO;
    }

//    NSArray *likedList = []
    FUNC_END();
    return YES;
}

+ (BOOL)commentMessage:(int)mid withContent:(NSString *)content {
    FUNC_START();
    HttpData *data = [HttpData data];
    User *user = [MessageLogic user];
    [data setIntValue:user.uid forKey:@"uid"];
    [data setValue:content forKey:@"content"];
    [data setIntValue:mid forKey:@"mid"];
    BOOL ret = [[HttpTransfer transfer] asyncPost:[data getJsonString] to:@"CommentMessage" withEventName:ASYNC_EVENT_COMMENTMESSAGE];
    if (!ret) {
        L(@"CommentMessage failed");
        FUNC_END();
        return NO;
    }
    FUNC_END();
    return YES;
}

@end
