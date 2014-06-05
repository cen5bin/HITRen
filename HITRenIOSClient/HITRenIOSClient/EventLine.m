//
//  EventLine.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-6-5.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "EventLine.h"


@implementation EventLine

@dynamic uid;
@dynamic seq;
@dynamic list;

@synthesize eids = _eids;

- (NSMutableArray *)getEids {
    if (_eids) return _eids;
    if (self.list) _eids = [NSKeyedUnarchiver unarchiveObjectWithData:self.list];
    else _eids = [[NSMutableArray alloc] init];
    return _eids;
}

- (void)update {
    self.list = [NSKeyedArchiver archivedDataWithRootObject:self.eids];
}
@end
