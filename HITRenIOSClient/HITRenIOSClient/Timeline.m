//
//  Timeline.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-4-28.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "Timeline.h"

@implementation Timeline

- (id)init {
    if (self = [super init]) {
        self.mids = [[NSMutableArray alloc] init];
        self.messagesDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

@end
