//
//  TestRelationship.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-1-2.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "TestRelationship.h"
#import "User.h"
#import "RelationShip.h"
#import "UserSimpleLogic.h"
#import "RelationshipLogic.h"

void testConcernUser(int uid) {
    User *user = [[User alloc] init];
    user.email = [NSString stringWithFormat:@"%dzzzaaa@163.com", 0];
    user.password = @"123";
    RelationShip *relationShip = [[RelationShip alloc] init];
    user.relationShip = relationShip;
    UserSimpleLogic *logic = [[UserSimpleLogic alloc] initWithUser:user];
    [logic login];
    RelationshipLogic *logic1 = [[RelationshipLogic alloc] initWithUser:user];
//    for (int i = 40; i < 50; i++)
    [logic1 concernUser:uid inGroup:@"default"];
//    [logic1 concernUser:<#(int)#> inGroups:<#(NSArray *)#>]
}