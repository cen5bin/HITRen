//
//  EventLogic.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-6-5.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "BaseLogic.h"

@interface EventLogic : BaseLogic

+ (BOOL)uploadEvent:(NSDictionary *)info;
+ (BOOL)downloadEventLine;
+ (BOOL)downloadEventInfos:(NSArray *)eids;

@end
