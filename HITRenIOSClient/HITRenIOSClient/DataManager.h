//
//  DataManager.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-1.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBController.h"

@class Timeline, Message, UserInfo, Notice,LikedList,Comment,GoodsLine,GoodsInfo,ThingsInfo,ThingsLine;
@interface DataManager : NSObject

+ (Timeline *)timeline;
+ (Message *)getMessage;
+ (UserInfo *)getUserInfo;
+ (UserInfo *)getUserInfoOfUid:(int)uid;

+ (NSArray *)messagesInPage:(int)page;
+ (Message *)getMessageOfMid:(int)mid;

+ (Notice *)getNoticeOfUid:(int)uid atIndex:(int)index;
+ (Notice *)getLastNoticeOfUid:(int)uid;
+ (Notice *)getNotice;
+ (Notice *)activitiesAtIndex:(int)index;

+ (NSArray *)getLikedList:(NSArray *)mids;
+ (LikedList *)getLikedListOfMid:(int)mid;
+ (LikedList *)getLikedList;

+ (NSArray *)getCommentList:(NSArray *)mids;
+ (Comment *)getCommentOfMid:(int)mid;
+ (Comment *)getComment;

+ (GoodsLine *)goodsLine;
+ (NSArray *)getGoodsList:(NSArray *)gids;
+ (GoodsInfo *)getGoodsInfo;
+ (GoodsInfo *)getGoodsInfoOfGid:(int)gid;

+ (ThingsLine *)thingsLine;
+ (NSArray *)getThingsList:(NSArray *)tids;
+ (ThingsInfo *)getThingsInfo;
+ (ThingsInfo *)getThingsInfoOfTid:(int)tid;


+ (void)deleteEntity:(NSManagedObject *)entity;
+ (void)save;

@end
