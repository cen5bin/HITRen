//
//  Notice.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-6.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NoticeObject;
@interface Notice : NSManagedObject {
    NSMutableArray *_notices;
}

@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) NSData * data;
@property (nonatomic, retain) NSNumber *index;
@property (nonatomic, retain, getter = getNotices) NSMutableArray *notices;

- (void)addNotice:(NoticeObject *)notice;
- (BOOL)full;

@end
