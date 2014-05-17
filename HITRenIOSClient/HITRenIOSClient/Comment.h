//
//  Comment.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-17.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Message;

@interface Comment : NSManagedObject {
    NSMutableArray *_commentList;
}

@property (nonatomic, retain) NSData * list;
@property (nonatomic, retain) NSNumber * seq;
@property (nonatomic, retain) NSNumber * cid;
@property (nonatomic, retain) Message *messageInfo;

@property (nonatomic, retain ,getter = getCommentList) NSMutableArray *commentList;

- (void)update;
@end
