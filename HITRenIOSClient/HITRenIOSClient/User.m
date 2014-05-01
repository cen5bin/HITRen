//
//  User.m
//  Test
//
//  Created by wubincen on 13-12-13.
//  Copyright (c) 2013年 wubincen. All rights reserved.
//

#import "User.h"
#import "RelationShip.h"
#import "Timeline.h"

@implementation User

- (id)init {
    if (self = [super init]) {
        self.relationShip = [[RelationShip alloc] init];
        self.timeline = [[Timeline alloc] init];
    }
    return self;
}

- (void)print {
    NSLog(@"uid %d",self.uid);
    NSLog(@"email %@",self.email);
    NSLog(@"password %@",self.password);
    NSLog(@"seq %d",self.seq);
    NSLog(@"birthday %@",self.birthday);
    NSLog(@"hometown %@",self.hometown);
    NSLog(@"sex %d",self.sex);
    NSLog(@"username %@",self.username);
    
}

- (void)dealloc {
    self.password = nil;
    self.email = nil;
    self.username = nil;
}

@end
