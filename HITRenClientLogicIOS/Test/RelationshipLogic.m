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
    NSMutableDictionary *ret = [HttpTransfer syncPost:request to:@"AddConcernlistGroup"];
    if (![[ret objectForKey:@"SUC"] boolValue]) {
        LOG(@"addConcernlistGroup fail");
        FUNC_END();
        return NO;
    }
    LOG(@"addConcernlistGroup succ");
    FUNC_END();
    return  YES;
}

- (BOOL)deleteGroup:(NSString *)gname {
    FUNC_START();
    HttpData *data = [[HttpData alloc]init];
    [data setIntValue:self.user.uid forKey:@"uid"];
    [data setValue:gname forKey:@"gname"];
    NSString *request = [NSString stringWithFormat:@"data=%@",stringToUrlString([data getJsonString])];
    NSMutableDictionary *ret = [HttpTransfer syncPost:request to:@"DeleteConcernlistGroup"];
    if (![[ret objectForKey:@"SUC"] boolValue]) {
        LOG(@"deleteConcernlistGroup fail");
        FUNC_END();
        return NO;
    }
    LOG(@"deleteConcernlistGroup succ");

    FUNC_END();
    return YES;
}

- (BOOL)renameGroup:(NSString *)gname1 newName:(NSString *)gname2 {
    FUNC_START();
    HttpData *data = [[HttpData alloc]init];
    [data setIntValue:self.user.uid forKey:@"uid"];
    [data setValue:gname1 forKey:@"gname1"];
    [data setValue:gname2 forKey:@"gname2"];
    NSString *request = [NSString stringWithFormat:@"data=%@",stringToUrlString([data getJsonString])];
    NSMutableDictionary *ret = [HttpTransfer syncPost:request to:@"RenameConcernlistGroup"];
    if (![[ret objectForKey:@"SUC"] boolValue]) {
        LOG(@"renameGroup fail");
        FUNC_END();
        return NO;
    }
    LOG(@"renameGroup succ");

    FUNC_END();
    return YES;
}

- (BOOL) moveUsers:(NSArray *)users fromGroup:(NSString *)gname toGroups:(NSArray *)gnames {
    FUNC_START();
    HttpData *data = [[HttpData alloc] init];
    [data setIntValue:self.user.uid forKey:@"uid"];
    [data setValue:users forKey:@"users"];
    [data setValue:gname forKey:@"gname"];
    [data setValue:gnames forKey:@"gnames"];
    NSString *request = [NSString stringWithFormat:@"data=%@",stringToUrlString([data getJsonString])];
    NSMutableDictionary *ret = [HttpTransfer syncPost:request to:@"MoveUsersFromGroupToGroups"];
    if (![[ret objectForKey:@"SUC"] boolValue]) {
        LOG(@"MoveUsersFromGroupToGroups fail");
        FUNC_END();
        return NO;
    }
    LOG(@"MoveUsersFromGroupToGroups succ");
    FUNC_END();
    return YES;
}

- (BOOL) moveUsers:(NSArray *)users fromGroup:(NSString *)gname0 toGroup:(NSString *)gname {
    FUNC_START();
    BOOL ret = [self moveUsers:users fromGroup:gname0 toGroups:[NSArray arrayWithObjects:gname, nil]];
    FUNC_END();
    return ret;
}

- (BOOL) copyUsers:(NSArray *)users toGroups:(NSArray *)gnames {
    FUNC_START();
    HttpData *data = [[HttpData alloc] init];
    [data setIntValue:self.user.uid forKey:@"uid"];
    [data setValue:users forKey:@"users"];
    [data setValue:gnames forKey:@"gnames"];
    NSString *request = [NSString stringWithFormat:@"data=%@",stringToUrlString([data getJsonString])];
    NSMutableDictionary *ret = [HttpTransfer syncPost:request to:@"CopyUsersToGroups"];
    if (![[ret objectForKey:@"SUC"] boolValue]) {
        LOG(@"CopyUsersToGroups fail");
        FUNC_END();
        return NO;
    }
    LOG(@"CopyUsersToGroups succ");
    FUNC_END();
    return YES;
}

- (BOOL) copyUsers:(NSArray *)users toGroup:(NSString *)gname {
    FUNC_START();
    BOOL ret = [self copyUsers:users toGroups:[NSArray arrayWithObjects:gname, nil]];
    FUNC_END();
    return ret;
}

- (BOOL)deleteUsers:(NSArray *)users fromGroup:(NSString *)gname {
    FUNC_START();
    HttpData *data = [[HttpData alloc] init];
    [data setIntValue:self.user.uid forKey:@"uid"];
    [data setValue:users forKey:@"users"];
    [data setValue:gname forKey:@"gname"];
    NSString *request = [NSString stringWithFormat:@"data=%@",stringToUrlString([data getJsonString])];
    NSMutableDictionary *ret = [HttpTransfer syncPost:request to:@"DeleteUsersFromGroup"];
    if (![[ret objectForKey:@"SUC"] boolValue]) {
        LOG(@"DeleteUsersFromGroup fail");
        FUNC_END();
        return NO;
    }
    LOG(@"DeleteUsersFromGroup succ");
    FUNC_END();
    return YES;
}
@end
