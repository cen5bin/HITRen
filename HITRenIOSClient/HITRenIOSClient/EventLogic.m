//
//  EventLogic.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-6-5.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "EventLogic.h"
#import "HttpData.h"
#import "User.h"
#import "AppData.h"
#import "EventLine.h"

@implementation EventLogic

+ (BOOL)uploadEvent:(NSDictionary *)info from:(NSString *)classname{
    L([info description]);
    HttpData *data = [HttpData data];
    User *user = [EventLogic user];
    [data setIntValue:user.uid forKey:@"uid"];
    [data setValue:[info objectForKey:@"eid"] forKey:@"eid"];
    [data setValue:[info objectForKey:@"time"] forKey:@"time"];
    [data setValue:[info objectForKey:@"reminds"] forKey:@"reminds"];
    [data setValue:[info objectForKey:@"description"] forKey:@"description"];
    [data setValue:[info objectForKey:@"place"] forKey:@"place"];
    BOOL ret = [[HttpTransfer transfer] asyncPost:[data getJsonString] to:@"UploadEvent" withEventName:ASYNC_EVENT_UPLOADEVENT fromClass:classname];
    if (ret) {
        L(@"upload event fail");
        return NO;
    }
    return YES;
}

+ (BOOL)downloadEventLinefrom:(NSString *)classname {
    HttpData *data = [HttpData data];
    User *user = [EventLogic user];
    [data setIntValue:user.uid forKey:@"uid"];
    [data setIntValue:[[[AppData sharedInstance] getEventLine].seq intValue] forKey:@"seq"];
    LOG(@"seq %d", [[[AppData sharedInstance] getEventLine].seq intValue]);
    BOOL ret = [[HttpTransfer transfer] asyncPost:[data getJsonString] to:@"DownloadEventLine" withEventName:ASYNC_EVENT_DOWNLOADEVENTLINE fromClass:classname];
    if (!ret) {
        L(@"download eventline fail");
        return NO;
    }
    return YES;
}

+ (BOOL)downloadEventInfos:(NSArray *)eids from:(NSString *)classname{
    AppData *appData = [AppData sharedInstance];
    NSArray *tmp = [appData eventInfosNeedDownload:eids];
    HttpData *data = [HttpData data];
    [data setValue:tmp forKey:@"datas"];
    BOOL ret = [[HttpTransfer transfer] asyncPost:[data getJsonString] to:@"DownloadEventInfos" withEventName:ASYNC_EVENT_DOWNLOADEVENTSINFO fromClass:classname];
    if (!ret) {
        L(@"download eventinfo fail");
        return NO;
    }
    return YES;

}

+ (BOOL)deleteEvent:(NSString *)eid from:(NSString *)classname {
    AppData *appData = [AppData sharedInstance];
    HttpData *data = [HttpData data];
    [data setIntValue:[appData getUid] forKey:@"uid"];
    [data setValue:eid forKey:@"eid"];
    BOOL ret = [[HttpTransfer transfer] asyncPost:[data getJsonString] to:@"DeleteEvent" withEventName:ASYNC_EVENT_DELETEEVENT fromClass:classname];
    if (!ret) {
        L(@"delete eventinfo fail");
        return NO;
    }
    return YES;

}

@end
