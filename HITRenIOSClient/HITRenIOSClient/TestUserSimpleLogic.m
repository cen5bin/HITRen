//
//  TestUserSimpleLogic.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-1-1.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "TestUserSimpleLogic.h"
#import "User.h"
#import "RelationShip.h"
#import "UserSimpleLogic.h"

void testUserSimpleLogic() {
    User *user = [[User alloc] init];
    user.email = @"bin@163.com";
    user.password = @"123";
    RelationShip *relationShip = [[RelationShip alloc] init];
    user.relationShip = relationShip;
    UserSimpleLogic *logic = [[UserSimpleLogic alloc] initWithUser:user];
    [logic signUp];
    [logic login];

}

void registerSomeUsers() {
    for (int i = 0; i < 20; i++) {
        User *user = [[User alloc] init];
        user.email = [NSString stringWithFormat:@"%dzzzaaa@163.com", i];
        user.password = @"123";
        RelationShip *relationShip = [[RelationShip alloc] init];
        user.relationShip = relationShip;
        UserSimpleLogic *logic = [[UserSimpleLogic alloc] initWithUser:user];
        [logic signUp];
    }
}