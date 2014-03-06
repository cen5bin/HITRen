//
//  BaseLogic.m
//  Test
//
//  Created by wubincen on 13-12-21.
//  Copyright (c) 2013年 wubincen. All rights reserved.
//

#import "BaseLogic.h"
#import "User.h"

static User *user;
@implementation BaseLogic

+ (User*)user {
    if (!user)
        user = [[User alloc] init];
    return user;
}


- (id)init {
    if (self = [super init]) {
        httpTransfer = [[HttpTransfer alloc] init];
    }
    return self;
}

- (id)initWithUser:(User *)user {
    if (self = [super init]) {
        self.user = user;
        httpTransfer = [[HttpTransfer alloc] init];
    }
    return self;
}



@end
