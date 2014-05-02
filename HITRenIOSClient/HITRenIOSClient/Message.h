//
//  Message.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-2.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Comment;

@interface Message : NSManagedObject {
    NSMutableArray *_likedList;
}

@property (nonatomic, retain) NSNumber * mid;
@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSData * likedlist;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * sharedCount;
@property (nonatomic, retain) NSNumber * seq;
@property (nonatomic, retain) Comment *comment;

@property (nonatomic, retain, getter = getLikedList, setter = setLikedList:) NSMutableArray *likedList;

@end
