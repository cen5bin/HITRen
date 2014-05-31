//
//  GoodsInfo.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-30.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "GoodsInfo.h"


@implementation GoodsInfo

@dynamic gid;
@dynamic name;
@dynamic desc;
@dynamic pics;
@dynamic time;
@dynamic price;
@dynamic uid;
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
