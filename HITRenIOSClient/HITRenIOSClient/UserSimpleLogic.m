//
//  UserSimpleLogic.m
//  Test
//
//  Created by wubincen on 13-12-13.
//  Copyright (c) 2013年 wubincen. All rights reserved.
//

#import "UserSimpleLogic.h"
#import "HttpTransfer.h"
#import "LogKit.h"
#import "HttpData.h"
#import "User.h"
#import "XmppConnector.h"
#import "AppData.h"
#import "UserInfo.h"

@implementation UserSimpleLogic


+ (BOOL)login {
    FUNC_START();
    User *user = [UserSimpleLogic user];
    HttpData *data = [HttpData data];
    [data setValue:user.email forKey:@"email"];
    [data setValue:user.password forKey:@"password"];
    NSString *requestString = [data getJsonString];
    HttpTransfer *httpTransfer = [HttpTransfer sharedInstance];
    NSMutableDictionary *ret = [httpTransfer syncPost:requestString to:@"Login"];
    if (![[ret objectForKey:@"SUC"] boolValue]) {
        LOG(@"login fail");
        FUNC_END();
        return NO;
    }
    user.uid = [[ret objectForKey:@"uid"] intValue];
    XmppConnector *connector = [XmppConnector sharedInstance];
    connector.uid = user.uid;
    connector.password = user.password;
    [connector connect];
    LOG(@"login succ");
    FUNC_END();
    return YES;
}

+ (BOOL)signUp {
    FUNC_START();
    User *user = [UserSimpleLogic user];
    HttpData *data = [HttpData data];
    [data setValue:user.email forKey:@"email"];
    [data setValue:user.password forKey:@"password"];
    
    HttpTransfer *httpTransfer = [HttpTransfer sharedInstance];
    NSMutableDictionary *ret = [httpTransfer syncPost:[data getJsonString] to:@"Register"];
    if (![[ret objectForKey:@"SUC"] boolValue]) {
        LOG(@"signUp fail");
        L([ret objectForKey:@"INFO"]);
        FUNC_END();
        return NO;
    }
    user.uid = [[ret objectForKey:@"uid"] intValue];
    user.seq = [[ret objectForKey:@"seq"] intValue];
    LOG(@"signUp succ");
    FUNC_END();
    return YES;
}

+ (BOOL)downloadInfo {
    FUNC_START();
    HttpData *data = [HttpData data];
    User *user = [UserSimpleLogic user];
    [data setValue:[NSString stringWithFormat:@"%d", user.uid] forKey:@"uid"];
    [data setValue:[NSString stringWithFormat:@"%d", user.seq] forKey:@"seq"];
    HttpTransfer *httpTransfer = [HttpTransfer sharedInstance];
    NSMutableDictionary *ret = [httpTransfer syncPost:[data getJsonString] to:@"DownloadUserInfo"];
    if (![[ret objectForKey:@"SUC"] boolValue]) {
        [UserSimpleLogic loadUserInfo];
        LOG(@"downloadInfo fail");
        FUNC_END();
        if ([[ret objectForKey:@"INFO"] isEqualToString:@"newest"])
            return YES;
        return NO;
    }
    LOG(@"downloadInfo succ");
    [UserSimpleLogic unpackUserInfoData:[ret objectForKey:@"DATA"]];
    [UserSimpleLogic save];
    [user print];
    FUNC_END();
    return YES;
}

+ (BOOL)updateInfofrom:(NSString *)classname {
    FUNC_START();
    HttpData *data = [UserSimpleLogic packUserInfoData];
    HttpTransfer *httpTransfer = [HttpTransfer transfer];
    [httpTransfer asyncPost:[data getJsonString] to:@"UpdateUserInfo" withEventName:ASYNC_EVENT_UPDATEUSETINFO fromClass:classname];
    FUNC_END();
    return YES;
}

+ (BOOL)updateInfoFinished:(NSDictionary*)ret {
    FUNC_START();
    if (![[ret objectForKey:@"SUC"] boolValue]) {
        LOG(@"updateInfo fail");
        FUNC_END();
        return NO;
    }
    User *user = [UserSimpleLogic user];
    user.seq++;
    [UserSimpleLogic save];
    LOG(@"updateInfo succ");
    FUNC_END();
    return YES;
}

+ (BOOL)downloadUseInfos:(NSArray *)uids from:(NSString *)classname{
    HttpData *data = [HttpData data];
    AppData *appData = [AppData sharedInstance];
    NSArray *array = [appData userInfosNeedDownload:uids];
    [data setValue:array forKey:@"datas"];
    BOOL ret = [[HttpTransfer transfer] asyncPost:[data getJsonString] to:@"NewDownloadUserInfo" withEventName:ASYNC_EVENT_DOWNLOADUSERINFOS fromClass:classname];
    if (!ret) {
        L(@"download userinfos fail");
        return NO;
    }
    return YES;
}

+ (void)save {
    User *user = [UserSimpleLogic user];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:user.username forKey:@"username"];
    [userDefaults setObject:user.password forKey:@"password"];
    [userDefaults setObject:user.birthday forKey:@"birthday"];
    [userDefaults setObject:user.hometown forKey:@"hometown"];
    [userDefaults setObject:[NSNumber numberWithInt:user.sex] forKey:@"sex"];
    [userDefaults setObject:user.pic forKey:@"pic"];
    [userDefaults synchronize];

}

+ (HttpData *)packUserInfoData {
    HttpData *data = [[HttpData alloc] init];
    User *user = [UserSimpleLogic user];
    [data setValue:user.email forKey:@"email"];
    [data setValue:user.password forKey:@"password"];
    [data setValue:user.birthday forKey:@"birthday"];
    [data setValue:user.hometown forKey:@"hometown"];
    [data setValue:user.username forKey:@"name"];
    [data setIntValue:user.seq forKey:@"seq"];
    [data setIntValue:user.uid forKey:@"uid"];
    [data setIntValue:user.status forKey:@"status"];
    [data setIntValue:user.sex forKey:@"sex"];
    [data setValue:user.pic forKey:@"pic"];
    return data;
}

+ (void)unpackUserInfoData:(NSDictionary*)dic {
    self.user.seq = [[dic objectForKey:@"seq"] intValue];
    self.user.sex = [[dic objectForKey:@"sex"] intValue];
    self.user.signature = [dic objectForKey:@"signature"];
    self.user.password = [dic objectForKey:@"password"];
    self.user.email = [dic objectForKey:@"email"];
    self.user.username = [dic objectForKey:@"name"];
    self.user.birthday = [dic objectForKey:@"birthday"];
    self.user.hometown = [dic objectForKey:@"hometown"];
    self.user.status = [[dic objectForKey:@"status"] intValue];
    self.user.uid = [[dic objectForKey:@"uid"] intValue];
    self.user.pic = [dic objectForKey:@"pic"];
}


+ (void)loadUserInfo{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    User *user = [UserSimpleLogic user];
    user.username = [userDefaults objectForKey:@"username"];
    user.sex = [[userDefaults objectForKey:@"sex"] intValue];
    user.birthday = [userDefaults objectForKey:@"birthday"];
    user.hometown = [userDefaults objectForKey:@"hometown"];
    user.email = [userDefaults objectForKey:@"email"];
    user.pic = [userDefaults objectForKey:@"pic"];
}


+ (void)userInfosDidDownload:(NSDictionary *)data {
    AppData *appData = [AppData sharedInstance];
    for (NSNumber *key in [data allKeys]) {
        UserInfo *userInfo = [appData userInfoForId:[key intValue]];
        NSDictionary *ui = [data objectForKey:key];
        if ([userInfo.seq isEqualToNumber:[ui objectForKey:@"seq"]]) continue;
        userInfo.uid = [ui objectForKey:@"uid"];
        userInfo.username = [ui objectForKey:@"name"];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        format.dateFormat = @"yyyy-MM-dd";
        userInfo.birthday = [format dateFromString:[ui objectForKey:@"birthday"]];
        userInfo.sex = [ui objectForKey:@"sex"];
        userInfo.hometown = [ui objectForKey:@"hometown"];
        userInfo.seq = [ui objectForKey:@"seq"];
        userInfo.pic = [ui objectForKey:@"pic"];
    }
    [AppData saveData];

}

+ (BOOL)logout {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:nil forKey:@"username"];
    [userDefaults setObject:nil forKey:@"password"];
    [userDefaults setObject:nil forKey:@"birthday"];
    [userDefaults setObject:nil forKey:@"hometown"];
    [userDefaults setObject:[NSNumber numberWithInt:0] forKey:@"sex"];
    [userDefaults setObject:nil forKey:@"pic"];
    [userDefaults synchronize];
    return YES;
}

@end
