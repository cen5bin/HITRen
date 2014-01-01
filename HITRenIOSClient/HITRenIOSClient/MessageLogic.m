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

@implementation MessageLogic

- (BOOL)sendShortMessage:(NSString *)message {
    FUNC_START();
    BOOL ret = [self sendShortMessage:message toGroups:nil];
    FUNC_END();
    return ret;
}

- (BOOL)sendShortMessage:(NSString *)message toGroup:(NSString *)gname {
    FUNC_START();
    BOOL ret = [self sendShortMessage:message toGroups:[NSArray arrayWithObjects:gname, nil]];
    FUNC_END();
    return ret;
}

- (BOOL)sendShortMessage:(NSString *)message toGroups:(NSArray *)gnames {
    FUNC_START();
    HttpData *data = [HttpData data];
    [data setIntValue:self.user.uid forKey:@"uid"];
    [data setValue:message forKey:@"message"];
    if (!gnames) [data setIntValue:0 forKey:@"auth"];
    else {
        [data setIntValue:1 forKey:@"auth"];
        [data setValue:gnames forKey:@"gnames"];
    }
    NSString *request = [NSString stringWithFormat:@"data=%@",stringToUrlString([data getJsonString])];
    LOG([httpTransfer description]);
    BOOL ret = [httpTransfer asyncPost:request to:@"SendShortMessage"];
    if (!ret) {
        LOG(@"SendShortMessage fail");
        FUNC_END();
        return NO;
    }
    LOG(@"SendShortMessage succ");
    FUNC_END();
    return YES;
}
@end
