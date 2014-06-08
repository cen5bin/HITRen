//
//  TradeLogic.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-30.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "BaseLogic.h"

@interface TradeLogic : BaseLogic

+ (BOOL)uploadGoodsInfo:(NSDictionary *)dic;
+ (BOOL)downloadGoodsLine;
+ (BOOL)downloadGoodsInfo:(NSArray *)gids;
+ (BOOL)deleteGoods:(int)gid;
+ (BOOL)downloadMyGoods;
@end
