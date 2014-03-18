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
    user.email = [NSString stringWithFormat:@"ll1bin@163.com"];
    user.password = @"123";
    RelationShip *relationShip = [[RelationShip alloc] init];
    user.relationShip = relationShip;
//    UserSimpleLogic *logic = [[UserSimpleLogic alloc] initWithUser:user];
//    [logic signUp];
    [UserSimpleLogic login];
    RelationshipLogic *logic1 = [[RelationshipLogic alloc] initWithUser:user];
    [logic1 addGroup:@"asd"];
//    for (int i = 40; i < 50; i++)
    [logic1 concernUser:uid inGroup:@"asd"];
//    [logic1 concernUser:<#(int)#> inGroups:<#(NSArray *)#>]
}

void testDeleteConcernedUser(int uid) {
    User *user = [[User alloc] init];
    user.email = [NSString stringWithFormat:@"ll1bin@163.com"];
    user.password = @"123";
    RelationShip *relationShip = [[RelationShip alloc] init];
    user.relationShip = relationShip;
//    UserSimpleLogic *logic = [[UserSimpleLogic alloc] initWithUser:user];
    [UserSimpleLogic login];
    RelationshipLogic *logic1 = [[RelationshipLogic alloc] initWithUser:user];
    [logic1 deleteConcernedUser:uid];

}