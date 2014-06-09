//
//  MessageLogic.h
//  Test
//
//  Created by wubincen on 14-1-1.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "BaseLogic.h"

@interface MessageLogic : BaseLogic

//+ (BOOL)sendShortMessage:(NSString *)message;
//+ (BOOL)sendShortMessage:(NSString *)message toGroup:(NSString *)gname;
//+ (BOOL)sendShortMessage:(NSString *)message toGroups:(NSArray *)gnames;
+ (BOOL)downloadTimelinefrom:(NSString *)classname;
+ (BOOL)downloadMessages:(NSArray *)mids from:(NSString *)classname;
+ (BOOL)likeMessage:(int)mid from:(NSString *)classname;
+ (BOOL)dislikeMessage:(int)mid from:(NSString *)classname;
+ (BOOL)downloadLikedList:(NSArray *)mids from:(NSString *)classname;
+ (BOOL)commentMessage:(int)mid withContent:(NSString *)content from:(NSString *)classname;
+ (BOOL)downloadCommentList:(NSArray *)mids from:(NSString *)classname;
+ (BOOL)replyUser:(int)reuid atMessage:(int)mid withContent:(NSString *)content from:(NSString *)classname;

+ (BOOL)sendShortMessage:(NSString *)message andPics:(NSArray *)pics from:(NSString *)classname;

// 向uid发送聊天消息
+ (BOOL)sendMessage:(NSString *)message toUid:(int)uid;

@end
