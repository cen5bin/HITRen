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
+ (BOOL)likeMessage:(int)mid;
+ (BOOL)dislikeMessage:(int)mid;
+ (BOOL)downloadLikedList:(NSArray *)mids;
+ (BOOL)commentMessage:(int)mid withContent:(NSString *)content;
+ (BOOL)downloadCommentList:(NSArray *)mids;
+ (BOOL)replyUser:(int)reuid atMessage:(int)mid withContent:(NSString *)content;

+ (BOOL)sendShortMessage:(NSString *)message andPics:(NSArray *)pics;

// 向uid发送聊天消息
+ (BOOL)sendMessage:(NSString *)message toUid:(int)uid;

@end
