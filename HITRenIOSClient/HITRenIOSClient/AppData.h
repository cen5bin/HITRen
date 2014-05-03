//
//  AppData.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-2.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Timeline, Message, UserInfo;
@interface AppData : NSObject {
    Timeline *_timeline;
    NSMutableDictionary *_messages;
    NSMutableDictionary *_userInfos;
    
//    NSMutableArray *_messageList;
}

@property (nonatomic, strong, getter = getTimeline) Timeline *timeline;
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

//- (UserInfo *)getUserInfo:(int)uid;

//- (void)insertMessage:(Message *)message;
@end
