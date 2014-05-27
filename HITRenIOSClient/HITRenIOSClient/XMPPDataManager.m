//
//  XMPPDataManager.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-6.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "XMPPDataManager.h"
#import "NoticeObject.h"
#import "AppData.h"


@implementation XMPPDataManager

- (id)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataReceived:) name:XMPP_MESSAGE_RECEIVED object:nil];
    }
    return self;
}

- (void)dataReceived:(NSNotification *)notification {
    NSString *string = notification.object;
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    L([dic description]);
    int type = [[dic objectForKey:@"type"] intValue];
    NSDictionary *message = [dic objectForKey:@"content"];
    if (type == 0)
        [self dealWithChatMessage:message];
    else if (type == 1)
        [self dealWithSNSPushMessage:message];
}

- (void)dealWithSNSPushMessage:(NSDictionary *)dic {
    NoticeObject *object = [[NoticeObject alloc] init];
    object.content = dic;
    object.type = 1;
    AppData *appData = [AppData sharedInstance];
    [appData addNoticeObject:object from:0];
    [AppData saveData];
}

- (void)dealWithChatMessage:(NSDictionary *)dic {
    NoticeObject *object = [[NoticeObject alloc] init];
    object.content = dic;
    object.type = 1;
    AppData *appData = [AppData sharedInstance];
    [appData addNoticeObject:object from:[[dic objectForKey:@"uid"] intValue]];
    [AppData saveData];
    [[NSNotificationCenter defaultCenter] postNotificationName:XMPP_CHATMESSAGE_RECEIVED object:nil];
}


//本地推送
- (void)sendNotice:(NSString *)string {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification) {
        notification.fireDate = [[NSDate date] dateByAddingTimeInterval:5];
        notification.repeatInterval = 0;
        
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.alertBody = string;
//        notification.alertAction = string;
//        notification.hasAction = YES;
//        notification.alertBody = string;
        
        notification.applicationIconBadgeNumber = 1;
//        [[UIApplication sharedApplication]presentLocalNotificationNow:notification];
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

@end
