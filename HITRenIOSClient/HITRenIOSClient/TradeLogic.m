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
#import "AppData.h"
#import "GoodsLine.h"

@implementation TradeLogic

+ (BOOL)uploadGoodsInfo:(NSDictionary *)dic from:(NSString *)classname{
    FUNC_START();
    HttpData *data = [HttpData data];
    User *user = [TradeLogic user];
    [data setIntValue:user.uid forKey:@"uid"];
    [data setValue:[dic objectForKey:@"name"] forKey:@"name"];
    [data setValue:[dic objectForKey:@"pics"] forKey:@"pics"];
    [data setValue:[dic objectForKey:@"description"] forKey:@"description"];
    [data setValue:[dic objectForKey:@"price"] forKey:@"price"];
    BOOL ret = [[HttpTransfer transfer] asyncPost:[data getJsonString] to:@"UploadGoodsInfo" withEventName:ASYNC_EVENT_UPLOADGOODSINFO fromClass:classname];
    if (!ret) {
        L(@"upload goods info failed");
        FUNC_END();
       return NO;
    }
    FUNC_END();
    return YES;
}

+ (BOOL)downloadGoodsLinefrom:(NSString *)classname {
    FUNC_START();
    HttpData *data = [HttpData data];
    AppData *appData = [AppData sharedInstance];
    [data setIntValue:[appData.goodsLine.seq intValue] forKey:@"seq"];
    BOOL ret = [[HttpTransfer transfer] asyncPost:[data getJsonString] to:@"DownloadGoodsLine" withEventName:ASYNC_EVENT_DOWNLOADGOODSLINE fromClass:classname];
    if (!ret) {
        L(@"download goodsline failed");
        FUNC_END();
        return NO;
    }

    FUNC_END();
    return YES;
}

+ (BOOL)downloadGoodsInfo:(NSArray *)gids from:(NSString *)classname{
    FUNC_START();
    HttpData *data = [HttpData data];
    AppData *appData = [AppData sharedInstance];
    NSArray *tmp = [appData goodsInfoNeedDownload:gids];
    [data setValue:tmp forKey:@"gids"];
    BOOL ret = [[HttpTransfer transfer] asyncPost:[data getJsonString] to:@"DownloadGoodsInfo" withEventName:ASYNC_EVENT_DOWNLOADGOODSINFO fromClass:classname];
    if (!ret) {
        L(@"download goodsInfo failed");
        FUNC_END();
        return NO;
    }
    FUNC_END();
    return YES;
}

+ (BOOL)deleteGoods:(int)gid from:(NSString *)classname{
    HttpData *data = [HttpData data];
    User *user = [TradeLogic user];
    [data setIntValue:gid forKey:@"gid"];
    [data setIntValue:user.uid forKey:@"uid"];
    BOOL ret = [[HttpTransfer transfer] asyncPost:[data getJsonString] to:@"DeleteGoods" withEventName:ASYNC_EVENT_DELETEGOODSINFO fromClass:classname];
    if (!ret) {
        L(@"delete Goods failed");
        FUNC_END();
        return NO;
    }
    FUNC_END();
    return YES;
}

+ (BOOL)downloadMyGoodsfrom:(NSString *)classname{
    FUNC_START();
    HttpData *data = [HttpData data];
    AppData *appData = [AppData sharedInstance];
    [data setIntValue:[appData.goodsLine.seq intValue] forKey:@"seq"];
    [data setIntValue:[appData getUid] forKey:@"uid"];
    BOOL ret = [[HttpTransfer transfer] asyncPost:[data getJsonString] to:@"DownloadMyGoods" withEventName:ASYNC_EVENT_DOWNLOADMYGOODSLINE fromClass:classname];
    if (!ret) {
        L(@"download mygoodsline failed");
        FUNC_END();
        return NO;
    }
    
    FUNC_END();
    return YES;
}
@end
