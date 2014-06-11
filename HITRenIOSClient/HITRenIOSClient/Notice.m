//
//  Notice.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-6.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "Notice.h"
#import "NoticeObject.h"
#import "DataManager.h"

const int max_count = PAGE_NOTICE_COUNT;

@implementation Notice

@dynamic uid;
@dynamic data;
@dynamic index;
@synthesize notices = _notices;


- (void)addNotice:(NoticeObject *)notice {
    [self.notices addObject:notice];
    self.data = [NSKeyedArchiver archivedDataWithRootObject:self.notices];
//    [DataManager save];
//    self.data = [NSKeyedArchiver = ]
}

- (NSMutableArray *)getNotices {
    if (_notices) return _notices;
    if (self.data) _notices = [NSKeyedUnarchiver unarchiveObjectWithData:self.data];
    else _notices = [[NSMutableArray alloc] init];
    return _notices;
}

- (BOOL)full {
    return self.notices.count == max_count;
}
@end
