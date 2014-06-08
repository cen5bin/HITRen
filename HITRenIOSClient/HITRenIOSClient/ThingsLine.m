//
//  ThingsLine.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-31.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "ThingsLine.h"


@implementation ThingsLine

@dynamic data;
@dynamic seq;
@dynamic uid;
@synthesize tids = _tids;

- (NSMutableArray *)getTids {
    if (_tids) return _tids;
    if (self.data) _tids = [NSKeyedUnarchiver unarchiveObjectWithData:self.data];
    else _tids = [[NSMutableArray alloc] init];
    return _tids;
}

- (void)update {
    self.data = [NSKeyedArchiver archivedDataWithRootObject:self.tids];
}

@end
