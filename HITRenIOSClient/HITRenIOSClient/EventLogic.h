//
//  EventLogic.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-6-5.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "BaseLogic.h"

@interface EventLogic : BaseLogic

+ (BOOL)uploadEvent:(NSDictionary *)info from:(NSString *)classname;
+ (BOOL)downloadEventLinefrom:(NSString *)classname;
+ (BOOL)downloadEventInfos:(NSArray *)eids from:(NSString *)classname;
+ (BOOL)deleteEvent:(NSString *)eid from:(NSString *)classname;

@end
