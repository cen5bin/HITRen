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


+ (BOOL)downloadThingsLine{
    FUNC_START();
    HttpData *data = [HttpData data];
    AppData *appData = [AppData sharedInstance];
    [data setIntValue:[appData.thingsLine.seq intValue] forKey:@"seq"];
    BOOL ret = [[HttpTransfer transfer] asyncPost:[data getJsonString] to:@"DownloadThingsLine" withEventName:ASYNC_EVENT_DOWNLOADTHINGSLINE];
    if (!ret) {
        L(@"download thingsline failed");
        FUNC_END();
        return NO;
    }
    
    FUNC_END();
    return YES;

}

+ (BOOL)downloadThingsInfo:(NSArray *)tids {
    FUNC_START();
    HttpData *data = [HttpData data];
    AppData *appData = [AppData sharedInstance];
    NSArray *tmp = [appData thingsInfoNeedDownload:tids];
    [data setValue:tmp forKey:@"tids"];
    BOOL ret = [[HttpTransfer transfer] asyncPost:[data getJsonString] to:@"DownloadThingsInfo" withEventName:ASYNC_EVENT_DOWNLOADTHINGSINFO];
    if (!ret) {
        L(@"download thingsInfo failed");
        FUNC_END();
        return NO;
    }
    FUNC_END();
    return YES;

}

+ (BOOL)uploadThingsInfo:(NSDictionary *)dic {
    FUNC_START();
    HttpData *data = [HttpData data];
    User *user = [FindLogic user];
    [data setIntValue:user.uid forKey:@"uid"];
    [data setValue:[dic objectForKey:@"name"] forKey:@"name"];
    [data setValue:[dic objectForKey:@"pics"] forKey:@"pics"];
    [data setValue:[dic objectForKey:@"description"] forKey:@"description"];
    
    BOOL ret = [[HttpTransfer transfer] asyncPost:[data getJsonString] to:@"UploadThingsInfo" withEventName:ASYNC_EVENT_UPLOADTHINGSINFO];
    if (!ret) {
        L(@"upload things info failed");
        FUNC_END();
        return NO;
    }
    FUNC_END();
    return YES;
}

+ (BOOL)deleteThing:(int)tid {
    HttpData *data = [HttpData data];
    [data setIntValue:tid forKey:@"tid"];
    User *user = [FindLogic user];
    [data setIntValue: user.uid forKey:@"uid"];
    BOOL ret = [[HttpTransfer transfer] asyncPost:[data getJsonString] to:@"DeleteThing" withEventName:ASYNC_EVENT_DELETETHINGSINFO];
    if (!ret) {
        L(@"delete things info failed");
        FUNC_END();
        return NO;
    }
    FUNC_END();
    return YES;
}

+ (BOOL)downloadMyThingsLine {
    HttpData *data = [HttpData data];
    AppData *appData = [AppData sharedInstance];
    [data setIntValue:[appData.myThingsLine.seq intValue] forKey:@"seq"];
    [data setIntValue:[appData getUid] forKey:@"uid"];
    BOOL ret = [[HttpTransfer transfer] asyncPost:[data getJsonString] to:@"DownloadMyThings" withEventName:ASYNC_EVENT_DOWNLOADMYTHINGSLINE];
    if (!ret) {
        L(@"delete my things info failed");
        FUNC_END();
        return NO;
    }
    FUNC_END();
    return YES;
    
}

@end
