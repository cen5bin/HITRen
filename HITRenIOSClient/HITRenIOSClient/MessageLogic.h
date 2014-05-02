//
//  MessageLogic.h
//  Test
//
//  Created by wubincen on 14-1-1.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "BaseLogic.h"

@interface MessageLogic : BaseLogic

+ (BOOL)sendShortMessage:(NSString *)message;
+ (BOOL)sendShortMessage:(NSString *)message toGroup:(NSString *)gname;
+ (BOOL)sendShortMessage:(NSString *)message toGroups:(NSArray *)gnames;
+ (BOOL)downloadTimeline;
+ (BOOL)downloadMessages:(NSArray *)mids;


@end
