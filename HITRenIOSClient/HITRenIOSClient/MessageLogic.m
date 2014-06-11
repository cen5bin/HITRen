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
#import "XmppConnector.h"
#import "NoticeObject.h"

@implementation MessageLogic

+ (BOOL)sendShortMessage:(NSString *)message {
    FUNC_START();
    BOOL ret = [MessageLogic sendShortMessage:message toGroups:nil];
    FUNC_END();
    return ret;
}

+ (BOOL)sendShortMessage:(NSString *)message andPics:(NSArray *)pics from:(NSString *)classname{
    FUNC_START();
    HttpData *data = [HttpData data];
    User *user = [MessageLogic user];
    [data setIntValue:user.uid forKey:@"uid"];
    [data setValue:message forKey:@"message"];
    [data setIntValue:0 forKey:@"auth"];
    [data setValue:pics forKey:@"pics"];
    BOOL ret = [[HttpTransfer transfer] asyncPost:[data getJsonString] to:@"SendShortMessage" withEventName:ASYNC_EVENT_SENDSHORTMESSAGE fromClass:classname];
    if (!ret) {
        LOG(@"SendShortMessage fail");
        FUNC_END();
        return NO;
    }
    LOG(@"SendShortMessage succ");
    FUNC_END();
    return YES;

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

+ (BOOL)downloadTimelinefrom:(NSString *)classname{
    FUNC_START();
    HttpData *data = [HttpData data];
//    User *user = [MessageLogic user];
//    [data setIntValue:user.uid forKey:@"uid"];
    [data setIntValue:[DataManager timeline].seq.intValue forKey:@"seq"];
    BOOL ret = [[HttpTransfer transfer] asyncPost:[data getJsonString] to:@"DownloadTimeline" withEventName:ASYNC_EVENT_DOWNLOADTIMELINE fromClass:classname];
    if (!ret) {
        L(@"DownloadTimeline failed");
        FUNC_END();
        return NO;
    }
    FUNC_END();
    return YES;
}

+ (BOOL)downloadMessages:(NSArray *)mids from:(NSString *)classname{
    FUNC_START();
    HttpData *data = [HttpData data];
    [data setValue:mids forKey:@"mids"];
    BOOL ret = [[HttpTransfer transfer] asyncPost:[data getJsonString] to:@"DownloadMessages" withEventName:ASYNC_EVENT_DOWNLOADMESSAGES fromClass:classname];
    if (!ret) {
        L(@"DownloadMessages failed");
        FUNC_END();
        return NO;
    }
    FUNC_END();
    return YES;
}

+ (BOOL)likeMessage:(int)mid from:(NSString *)classname{
    FUNC_START();
    HttpData *data = [HttpData data];
    User *user = [MessageLogic user];
    [data setIntValue:mid forKey:@"mid"];
    [data setIntValue:user.uid forKey:@"uid"];
    BOOL ret = [[HttpTransfer transfer] asyncPost:[data getJsonString] to:@"LikeTheMessage" withEventName:ASYNC_EVENT_LIKEMESSAGE fromClass:classname];
    if (!ret) {
        L(@"LikeMessage failed");
        FUNC_END();
        return NO;
    }
    FUNC_END();
    return YES;
}

+ (BOOL)dislikeMessage:(int)mid from:(NSString *)classname{
    FUNC_START();
    HttpData *data = [HttpData data];
    User *user = [MessageLogic user];
    [data setIntValue:mid forKey:@"mid"];
    [data setIntValue:user.uid forKey:@"uid"];
    BOOL ret = [[HttpTransfer transfer] asyncPost:[data getJsonString] to:@"CancelLikeTheMessage" withEventName:ASYNC_EVENT_LIKEMESSAGE fromClass:classname];
    if (!ret) {
        L(@"CancelLikeMessage failed");
        FUNC_END();
        return NO;
    }
    FUNC_END();
    return YES;
}

+ (BOOL)downloadLikedList:(NSArray *)mids from:(NSString *)classname{
    FUNC_START();
    HttpData *data = [HttpData data];
    AppData *appData = [AppData sharedInstance];
    [data setValue:[appData likedListNeedDownload:mids] forKey:@"datas"];
    BOOL ret = [[HttpTransfer transfer] asyncPost:[data getJsonString] to:@"DownloadLikedList" withEventName:ASYNC_EVENT_DOWNLOADLIKEDLIST fromClass:classname];
    if (!ret) {
        L(@"DownloadLikedList failed");
        FUNC_END();
        return NO;
    }

//    NSArray *likedList = []
    FUNC_END();
    return YES;
}

+ (BOOL)commentMessage:(int)mid withContent:(NSString *)content from:(NSString *)classname{
    FUNC_START();
    HttpData *data = [HttpData data];
    User *user = [MessageLogic user];
    [data setIntValue:user.uid forKey:@"uid"];
    [data setValue:content forKey:@"content"];
    [data setIntValue:mid forKey:@"mid"];
    BOOL ret = [[HttpTransfer transfer] asyncPost:[data getJsonString] to:@"CommentMessage" withEventName:ASYNC_EVENT_COMMENTMESSAGE fromClass:classname];
    if (!ret) {
        L(@"CommentMessage failed");
        FUNC_END();
        return NO;
    }
    FUNC_END();
    return YES;
}

+ (BOOL)downloadCommentList:(NSArray *)mids from:(NSString *)classname{
    FUNC_START();
    HttpData *data = [HttpData data];
    AppData *appData = [AppData sharedInstance];
    [data setValue:[appData commentListNeedDownload:mids] forKey:@"datas"];
//    [data setValue:mids forKey:@"mids"];
    BOOL ret = [[HttpTransfer transfer] asyncPost:[data getJsonString] to:@"DownloadCommentList" withEventName:ASYNC_EVENT_DOWNLOADCOMMENTLIST fromClass:classname];
    if (!ret) {
        L(@"DownloadCommentList failed");
        FUNC_END();
        return NO;
    }
    FUNC_END();
    return YES;
}

+ (BOOL)replyUser:(int)reuid atMessage:(int)mid withContent:(NSString *)content from:(NSString *)classname{
    FUNC_START();
    HttpData *data = [HttpData data];
    User *user = [MessageLogic user];
    [data setIntValue:user.uid forKey:@"uid"];
    [data setIntValue:1 forKey:@"type"];
    [data setIntValue:reuid forKey:@"reuid"];
    [data setValue:content forKey:@"content"];
    [data setIntValue:mid forKey:@"mid"];
    BOOL ret = [[HttpTransfer transfer] asyncPost:[data getJsonString] to:@"CommentMessage" withEventName:ASYNC_EVENT_COMMENTMESSAGE fromClass:classname];
    if (!ret) {
        L(@"CommentMessage failed");
        FUNC_END();
        return NO;
    }
    FUNC_END();
    return YES;
}

+ (BOOL)sendMessage:(NSString *)message toUid:(int)uid {
    FUNC_START();
    User *user = [MessageLogic user];
    
    NSMutableDictionary *body = [[NSMutableDictionary alloc] init];
    [body setObject:[NSNumber numberWithInt:0] forKey:@"type"];
    NSMutableDictionary *content = [[NSMutableDictionary alloc] init];
    [content setObject:[NSNumber numberWithInt:user.uid] forKey:@"uid"];
    [content setObject:message forKey:@"text"];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    [content setObject:[format stringFromDate:[NSDate date]] forKey:@"date"];
    [body setObject:content forKey:@"content"];
    NSData *data = [NSJSONSerialization dataWithJSONObject:body options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jid = [NSString stringWithFormat:@"hitrenuid%d@%@", uid, [[XmppConnector sharedInstance] getHostname]];
    NSXMLElement *m = [NSXMLElement elementWithName:@"message"];
    [m addAttributeWithName:@"to" stringValue:jid];
    NSXMLElement *element = [NSXMLElement elementWithName:@"body" stringValue:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
    [m addChild:element];
    [[XmppConnector sharedInstance] sendMessage:m];
    
    NoticeObject *obj = [[NoticeObject alloc] init];
    obj.content = content;
    obj.date = [format dateFromString: [content objectForKey:@"date"]];
    obj.type = 0;
    obj.isReply = YES;
    AppData *appData = [AppData sharedInstance];
    [appData addNoticeObject:obj from:uid];
    FUNC_END();
    return YES;
}

@end
