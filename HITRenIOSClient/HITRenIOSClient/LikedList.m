//
//  LikedList.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-10.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "LikedList.h"


@implementation LikedList

@dynamic mid;
@dynamic seq;
@dynamic list;
@synthesize userList = _userList;

- (NSMutableArray *)getUserlist {
    if (_userList) return _userList;
    if (self.list) _userList = [NSKeyedUnarchiver unarchiveObjectWithData:self.list];
    else _userList = [[NSMutableArray alloc] init];
    return _userList;
}

- (void)update {
    self.list = [NSKeyedArchiver archivedDataWithRootObject:self.userList];
}

@end
