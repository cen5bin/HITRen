//
//  FindLogic.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-31.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "BaseLogic.h"

@interface FindLogic : BaseLogic

+ (BOOL)uploadThingsInfo:(NSDictionary *)dic;
+ (BOOL)downloadThingsLine;
+ (BOOL)downloadThingsInfo:(NSArray *)tids;
+ (BOOL)deleteThing:(int)tid;

@end
