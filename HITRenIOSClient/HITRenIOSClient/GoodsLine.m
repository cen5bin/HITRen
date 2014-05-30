//
//  GoodsLine.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-30.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "GoodsLine.h"


@implementation GoodsLine

@dynamic data;
@dynamic seq;

@synthesize gids = _gids;

- (NSMutableArray *)getGids {
    if (_gids) return _gids;
    if (self.data) _gids = [NSKeyedUnarchiver unarchiveObjectWithData:self.data];
    else _gids = [[NSMutableArray alloc] init];
    return _gids;
}

- (void)update {
    self.data = [NSKeyedArchiver archivedDataWithRootObject:self.gids];
}

@end
