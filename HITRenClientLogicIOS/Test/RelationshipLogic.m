//
//  RelationshipLogic.m
//  Test
//
//  Created by wubincen on 13-12-20.
//  Copyright (c) 2013年 wubincen. All rights reserved.
//

#import "RelationshipLogic.h"
#import "Kit.h"
#import "HttpData.h"
#import "HttpTransfer.h"

@implementation RelationshipLogic

- (BOOL)concernUser:(int)uid inGroups:(NSArray *)gnames {
    FUNC_START();
    HttpData *data = [[HttpData alloc] init];
    [data setIntValue:self.user.uid forKey:@"uid"];
    [data setIntValue:uid forKey:@"uid1"];
    [data setValue:gnames forKey:@"gnames"];
    NSString *request = [NSString stringWithFormat:@"data=%@",stringToUrlString([data getJsonString])];
    NSMutableDictionary *ret = [HttpTransfer syncPost:request to:@"ConcernUser"];
    if (![[ret objectForKey:@"SUC"] boolValue]) {
        LOG(@"concernUser fail");
        FUNC_END();
        return NO;
    }
    LOG(@"concernUser succ");
    FUNC_END();
    return YES;
}

- (BOOL)addGroup:(NSString *)gname {
    FUNC_START();
    HttpData *data = [[HttpData alloc] init];
    [data setIntValue:self.user.uid forKey:@"uid"];
    [data setValue:gname forKey:@"gname"];
    NSString *request = [NSString stringWithFormat:@"data=%@",stringToUrlString([data getJsonString])];
    NSMutableDictionary *ret = [HttpTransfer syncPost:request to:@"AddGroup"];
    if (![[ret objectForKey:@"SUC"] boolValue]) {
        LOG(@"addGroup fail");
        FUNC_END();
        return NO;
    }
    LOG(@"addGroup succ");
    FUNC_END();
    return  YES;
}

- (BOOL)deleteGroup:(NSString *)gname {
    FUNC_START();
    HttpData *data = [[HttpData alloc]init];
    [data setIntValue:self.user.uid forKey:@"uid"];
    [data setValue:gname forKey:@"gname"];
    NSString *request = [NSString stringWithFormat:@"data=%@",stringToUrlString([data getJsonString])];
    NSMutableDictionary *ret = [HttpTransfer syncPost:request to:@"DeleteGroup"];
    if (![[ret objectForKey:@"SUC"] boolValue]) {
        LOG(@"deleteGroup fail");
        FUNC_END();
        return NO;
    }
    LOG(@"deleteGroup succ");

    FUNC_END();
    return YES;
}

@end
