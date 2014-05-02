//
//  AppData.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-2.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Timeline, Message;
@interface AppData : NSObject {
    Timeline *_timeline;
    NSMutableDictionary *_messages;
}

@property (nonatomic, strong, getter = getTimeline) Timeline *timeline;

+ (id)sharedInstance;
+ (void)saveData;

+ (Message *)newMessage;
- (Message *)messgeForId:(NSNumber *)mid;
- (void)insertMessage:(Message *)message;
@end
