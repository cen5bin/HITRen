//
//  Timeline.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-1.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "Timeline.h"


@implementation Timeline

@dynamic data;
@dynamic seq;
@synthesize mids = _mids;
//@dynamic mids;
- (NSMutableArray *)getMids {
    if (_mids) return _mids;
    if (self.data == nil) {
        _mids = [[NSMutableArray alloc] init];
        return _mids;
    }
    _mids = [NSKeyedUnarchiver unarchiveObjectWithData:self.data];
    return _mids;
}

- (void)update {
    self.data = [NSKeyedArchiver archivedDataWithRootObject:self.mids];
//    [self.managedObjectContext save:nil];
}

@end
