//
//  FindLogic.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-31.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "BaseLogic.h"

@interface FindLogic : BaseLogic

+ (BOOL)uploadThingsInfo:(NSDictionary *)dic from:(NSString *)classname;
+ (BOOL)downloadThingsLinefrom:(NSString *)classname;
+ (BOOL)downloadThingsInfo:(NSArray *)tids from:(NSString *)classname;
+ (BOOL)deleteThing:(int)tid from:(NSString *)classname;
+ (BOOL)downloadMyThingsLinefrom:(NSString *)classname;

@end
