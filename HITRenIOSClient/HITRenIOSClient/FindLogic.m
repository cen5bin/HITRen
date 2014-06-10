//
//  FindLogic.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-31.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "FindLogic.h"
#import "AppData.h"
#import "HttpData.h"
#import "ThingsLine.h"

@implementation FindLogic


+ (BOOL)downloadThingsLinefrom:(NSString *)classname{
    FUNC_START();
    HttpData *data = [HttpData data];
    AppData *appData = [AppData sharedInstance];
    [data setIntValue:[appData.thingsLine.seq intValue] forKey:@"seq"];
    BOOL ret = [[HttpTransfer transfer] asyncPost:[data getJsonString] to:@"DownloadThingsLine" withEventName:ASYNC_EVENT_DOWNLOADTHINGSLINE fromClass:classname];
    if (!ret) {
        L(@"download thingsline failed");
        FUNC_END();
        return NO;
    }
    
    FUNC_END();
    return YES;

}

+ (BOOL)downloadThingsInfo:(NSArray *)tids from:(NSString *)classname{
    FUNC_START();
    HttpData *data = [HttpData data];
    AppData *appData = [AppData sharedInstance];
    NSArray *tmp = [appData thingsInfoNeedDownload:tids];
    [data setValue:tmp forKey:@"tids"];
    BOOL ret = [[HttpTransfer transfer] asyncPost:[data getJsonString] to:@"DownloadThingsInfo" withEventName:ASYNC_EVENT_DOWNLOADTHINGSINFO fromClass:classname];
    if (!ret) {
        L(@"download thingsInfo failed");
        FUNC_END();
        return NO;
    }
    FUNC_END();
    return YES;

}

+ (BOOL)uploadThingsInfo:(NSDictionary *)dic from:(NSString *)classname{
    FUNC_START();
    HttpData *data = [HttpData data];
    User *user = [FindLogic user];
    [data setIntValue:user.uid forKey:@"uid"];
    [data setValue:[dic objectForKey:@"name"] forKey:@"name"];
    [data setValue:[dic objectForKey:@"pics"] forKey:@"pics"];
    [data setValue:[dic objectForKey:@"description"] forKey:@"description"];
    
    BOOL ret = [[HttpTransfer transfer] asyncPost:[data getJsonString] to:@"UploadThingsInfo" withEventName:ASYNC_EVENT_UPLOADTHINGSINFO fromClass:classname];
    if (!ret) {
        L(@"upload things info failed");
        FUNC_END();
        return NO;
    }
    FUNC_END();
    return YES;
}

+ (BOOL)deleteThing:(int)tid from:(NSString *)classname{
    HttpData *data = [HttpData data];
    [data setIntValue:tid forKey:@"tid"];
    User *user = [FindLogic user];
    [data setIntValue: user.uid forKey:@"uid"];
    BOOL ret = [[HttpTransfer transfer] asyncPost:[data getJsonString] to:@"DeleteThing" withEventName:ASYNC_EVENT_DELETETHINGSINFO fromClass:classname];
    if (!ret) {
        L(@"delete things info failed");
        FUNC_END();
        return NO;
    }
    FUNC_END();
    return YES;
}

+ (BOOL)downloadMyThingsLinefrom:(NSString *)classname {
    HttpData *data = [HttpData data];
    AppData *appData = [AppData sharedInstance];
    [data setIntValue:[appData.myThingsLine.seq intValue] forKey:@"seq"];
    [data setIntValue:[appData getUid] forKey:@"uid"];
    BOOL ret = [[HttpTransfer transfer] asyncPost:[data getJsonString] to:@"DownloadMyThings" withEventName:ASYNC_EVENT_DOWNLOADMYTHINGSLINE fromClass:classname];
    if (!ret) {
        L(@"delete my things info failed");
        FUNC_END();
        return NO;
    }
    FUNC_END();
    return YES;
    
}

+ (BOOL)searchThings:(NSString *)info from:(NSString *)classname {
    HttpData *data = [HttpData data];
    [data setValue:info forKey:@"info"];
    BOOL ret = [[HttpTransfer transfer] asyncPost:[data getJsonString] to:@"SearchThings" withEventName:ASYNC_EVENT_SEARCHTHINGS fromClass:classname];
    if (!ret) {
        L(@"search things  failed");
        FUNC_END();
        return NO;
    }
    FUNC_END();
    return YES;

}

@end
