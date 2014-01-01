//
//  TestMessageLogic.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-1-1.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "TestMessageLogic.h"
#import "UserSimpleLogic.h"
#import "User.h"
#import "RelationShip.h"
#import "MessageLogic.h"

void testSendShortMessage() {
    User *user = [[User alloc] init];
    user.email = @"bin@163.com";
    user.password = @"123";
    RelationShip *relationShip = [[RelationShip alloc] init];
    user.relationShip = relationShip;
    UserSimpleLogic *logic = [[UserSimpleLogic alloc] initWithUser:user];
//    [logic signUp];
    [logic login];
    MessageLogic *logic1 = [[MessageLogic alloc] initWithUser:user];
    [logic1 sendShortMessage:@"asdasd"];
}