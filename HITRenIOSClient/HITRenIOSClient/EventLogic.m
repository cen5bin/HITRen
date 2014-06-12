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
#import "Event.h"

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

+ (BOOL)setAlarm:(NSString *)eid {
    AppData *appData = [AppData sharedInstance];
    Event *event = [appData getEventOfEid:eid];
    if (!event) return NO;
    
    for (NSNumber *time in event.remindTimes) {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970: [event.time timeIntervalSince1970] - [time intValue]*60];
        notification.fireDate =  date;//[event.time dateByAddingTimeInterval:[time intValue]*60];
        NSDictionary *dic = @{@"eid":eid};
        notification.userInfo = dic;
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.timeZone=[NSTimeZone defaultTimeZone];
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        formater.dateFormat = @"yyyy-MM-dd HH:mm";
//        [formater str]
        notification.alertBody= [NSString stringWithFormat:@"时间: %@, 地点: %@, 事件:%@", [formater stringFromDate:event.time ], event.place, event.desc];   //@"顶部提示内容，通知时间到啦";
//        notification.soundName= UILocalNotificationDefaultSoundName;
//        notification.alertAction=NSLocalizedString(@"你锁屏啦，通知时间到啦", nil);
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    return YES;
}

+ (BOOL)cancelAlarm:(NSString *)eid {
    NSArray *array = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *notification in array)
        if ([[notification.userInfo objectForKey:@"eid"] isEqualToString:eid]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    return YES;
}

@end
