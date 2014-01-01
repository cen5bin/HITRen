//
//  BaseLogic.m
//  Test
//
//  Created by wubincen on 13-12-21.
//  Copyright (c) 2013年 wubincen. All rights reserved.
//

#import "BaseLogic.h"

@implementation BaseLogic

- (id)initWithUser:(User *)user {
    if (self = [super init]) {
        self.user = user;
        httpTransfer = [[HttpTransfer alloc] init];
    }
    return self;
}

@end
