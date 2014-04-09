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

- (BOOL)downloadInfo {
    FUNC_START();
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[NSString stringWithFormat:@"%d", self.user.uid] forKey:@"uid"];
    [dic setValue:[NSString stringWithFormat:@"%d", self.user.seq] forKey:@"seq"];
    NSString *requestString = [NSString stringWithFormat:@"data=%@",stringToUrlString([dic description])];
    NSMutableDictionary *ret = [httpTransfer syncPost:requestString to:@"DownloadUserInfo"];
    if (![[ret objectForKey:@"SUC"] boolValue]) {
        LOG(@"downloadInfo fail");
        FUNC_END();
        if ([[ret objectForKey:@"INFO"] isEqualToString:@"newest"])
            return YES;
        return NO;
    }
    LOG(@"downloadInfo succ");
    [self unpackUserInfoData:[ret objectForKey:@"DATA"]];
    [self.user print];
    FUNC_END();
    return YES;
}

+ (BOOL)updateInfo {
    FUNC_START();
    HttpData *data = [UserSimpleLogic packUserInfoData];
    HttpTransfer *httpTransfer = [HttpTransfer sharedInstance];
    NSMutableDictionary *ret = [httpTransfer syncPost:[data getJsonString] to:@"UpdateUserInfo"];
    if (![[ret objectForKey:@"SUC"] boolValue]) {
        LOG(@"updateInfo fail");
        FUNC_END();
        return NO;
    }
    User *user = [UserSimpleLogic user];
    user.seq++;
    LOG(@"updateInfo succ");
    FUNC_END();
    return YES;
}


+ (HttpData *)packUserInfoData {
    HttpData *data = [[HttpData alloc] init];
    User *user = [UserSimpleLogic user];
    [data setValue:user.email forKey:@"email"];
    [data setValue:user.password forKey:@"password"];
    [data setValue:user.birthday forKey:@"birthday"];
    [data setValue:user.hometown forKey:@"hometown"];
    [data setValue:user.username forKey:@"username"];
    [data setIntValue:user.seq forKey:@"seq"];
    [data setIntValue:user.uid forKey:@"uid"];
    [data setIntValue:user.status forKey:@"status"];
    [data setIntValue:user.sex forKey:@"sex"];
    return data;
}

- (void)unpackUserInfoData:(NSDictionary*)dic {
    self.user.seq = [[dic objectForKey:@"seq"] intValue];
    self.user.sex = [[dic objectForKey:@"sex"] intValue];
    self.user.signature = [dic objectForKey:@"signature"];
    self.user.password = [dic objectForKey:@"password"];
    self.user.email = [dic objectForKey:@"email"];
    self.user.username = [dic objectForKey:@"username"];
    self.user.birthday = [dic objectForKey:@"birthday"];
    self.user.hometown = [dic objectForKey:@"hometown"];
    self.user.status = [[dic objectForKey:@"status"] intValue];
    self.user.uid = [[dic objectForKey:@"uid"] intValue];
}

- (void) dealloc {
    self.user = nil;
}
@end
