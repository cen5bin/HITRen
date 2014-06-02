//
//  ThingsInfo.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-31.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "ThingsInfo.h"


@implementation ThingsInfo

@dynamic tid;
@dynamic name;
@dynamic desc;
@dynamic uid;
@dynamic time;
@dynamic pics;

@synthesize picNames = _picNames;

- (NSMutableArray *)getPicNames {
    if (_picNames) return _picNames;
    if (self.pics) _picNames = [NSKeyedUnarchiver unarchiveObjectWithData:self.pics];
    else _picNames = [[NSMutableArray alloc] init];
    return _picNames;
}

- (void)update {
    self.pics = [NSKeyedArchiver archivedDataWithRootObject:self.picNames];
}

@end
