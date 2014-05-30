//
//  TradeLogic.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-30.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "TradeLogic.h"
#import "HttpData.h"
#import "User.h"

@implementation TradeLogic

+ (BOOL)uploadGoodsInfo:(NSDictionary *)dic {
    FUNC_START();
    HttpData *data = [HttpData data];
    User *user = [TradeLogic user];
    [data setIntValue:user.uid forKey:@"uid"];
    [data setValue:[dic objectForKey:@"name"] forKey:@"name"];
    [data setValue:[dic objectForKey:@"pics"] forKey:@"pics"];
    [data setValue:[dic objectForKey:@"description"] forKey:@"description"];
    [data setValue:[dic objectForKey:@"price"] forKey:@"price"];
    BOOL ret = [[HttpTransfer transfer] asyncPost:[data getJsonString] to:@"UploadGoodsInfo" withEventName:ASYNC_EVENT_UPLOADGOODSINFO];
    if (!ret) {
        L(@"upload goods info failed");
        FUNC_END();
       return NO;
    }
    FUNC_END();
    return YES;
}
@end
