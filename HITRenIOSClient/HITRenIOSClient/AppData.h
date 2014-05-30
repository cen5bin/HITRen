//
//  AppData.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-2.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Timeline, Message, UserInfo, Notice, NoticeObject,LikedList,Comment;
@interface AppData : NSObject {
    Timeline *_timeline;
    NSMutableDictionary *_messages;
    NSMutableDictionary *_userInfos;
    NSMutableDictionary *_notices;
    NSMutableArray *_noticeLine;
    NSMutableDictionary *_likedLists;
//    NSMutableArray *_activityLine;
    
//    NSMutableArray *_messageList;
}

@property (nonatomic, strong, getter = getTimeline) Timeline *timeline;
@property (nonatomic, strong, getter = getNoticeLine) NSMutableArray *noticeLine;
//@property (nonatomic, strong) NSMutableDictionary *userInfos;
//@property (nonatomic, strong, getter = getMessageList) NSMutableArray *messageList;

+ (id)sharedInstance;
+ (void)saveData;

+ (Message *)newMessage;
- (id)init;
- (Message *)messgeForId:(int)mid;
- (UserInfo *)userInfoForId:(int)uid;
- (NSArray *)messagesNeedDownload;
- (NSArray *)messagesNeedDownloadFromIndex:(int)index;
- (NSArray *)getMessagesInPage:(int)page;
- (NSArray *)userInfosNeedDownload:(NSArray *)uids;
- (UserInfo *)readUserInfoForId:(int)uid;
- (Message *)readMessageForId:(int)mid;

- (Notice *)newNotice;
- (Notice *)lastNoticeOfUid:(int)uid;
- (Notice *)getNoticeOfUid:(int)uid atIndex:(int)index;
- (void)addNoticeObject:(NoticeObject *)noticeObject inNotice:(Notice *)notice;
- (void)addNoticeObject:(NoticeObject *)noticeObject from:(int)uid;
+ (NSString *)stringOfNoticeObject:(NoticeObject *)noticeObject;
- (NSString *)lastNoticeStringOfUid:(int)uid;
- (Notice *)activitiesAtIndex:(int)index;

- (NSArray *)likedListNeedDownload:(NSArray *)mids;
- (LikedList *)getLikedListOfMid:(int)mid;

- (NSArray *)commentListNeedDownload:(NSArray *)mids;
- (Comment *)getCommentOfMid:(int)mid;

- (void)storeImage:(UIImage *)image withFilename:(NSString *)filename;
- (UIImage *)getImage:(NSString *)filename;
//- (UserInfo *)getUserInfo:(int)uid;

//- (void)insertMessage:(Message *)message;
@end
