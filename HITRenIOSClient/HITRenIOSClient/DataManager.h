//
//  DataManager.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-1.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBController.h"

@class Timeline, Message, UserInfo, Notice,LikedList;
@interface DataManager : NSObject

+ (Timeline *)timeline;
+ (Message *)getMessage;
+ (UserInfo *)getUserInfo;
+ (UserInfo *)getUserInfoOfUid:(int)uid;
+ (NSArray *)messagesInPage:(int)page;

+ (Notice *)getNoticeOfUid:(int)uid atIndex:(int)index;
+ (Notice *)getLastNoticeOfUid:(int)uid;
+ (Notice *)getNotice;
+ (Notice *)activitiesAtIndex:(int)index;

+ (NSArray *)getLikedList:(NSArray *)mids;
+ (LikedList *)getLikedListOfMid:(int)mid;
+ (LikedList *)getLikedList;


+ (void)deleteEntity:(NSManagedObject *)entity;
+ (void)save;

@end
