//
//  TradeLogic.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-30.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "BaseLogic.h"

@interface TradeLogic : BaseLogic

+ (BOOL)uploadGoodsInfo:(NSDictionary *)dic from:(NSString *)classname;
+ (BOOL)downloadGoodsLinefrom:(NSString *)classname;
+ (BOOL)downloadGoodsInfo:(NSArray *)gids from:(NSString *)classname;
+ (BOOL)deleteGoods:(int)gid from:(NSString *)classname;
+ (BOOL)downloadMyGoodsfrom:(NSString *)classname;
@end
