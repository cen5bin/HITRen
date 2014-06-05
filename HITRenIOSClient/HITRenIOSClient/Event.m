//
//  Event.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-6-5.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "Event.h"


@implementation Event

@dynamic eid;
@dynamic time;
@dynamic desc;
@dynamic reminds;
@dynamic place;
@dynamic seq;

@synthesize remindTimes = _remindTimes;

- (NSMutableArray *)getRemindTimes {
    if (_remindTimes) return _remindTimes;
    if (self.reminds) _remindTimes = [NSKeyedUnarchiver unarchiveObjectWithData:self.reminds];
    else _remindTimes = [[NSMutableArray alloc] init];
    return _remindTimes;
}

- (void)update {
    self.reminds = [NSKeyedArchiver archivedDataWithRootObject:self.remindTimes];
}

@end
