//
//  RelationshipLogic.m
//  Test
//
//  Created by wubincen on 13-12-20.
//  Copyright (c) 2013年 wubincen. All rights reserved.
//

#import "RelationshipLogic.h"
#import "LogKit.h"
#import "HttpData.h"
#import "HttpTransfer.h"
#import "User.h"
#import "RelationShip.h"

@implementation RelationshipLogic

- (BOOL)concernUser:(int)uid inGroup:(NSString *)gname {
    FUNC_START();
    BOOL ret = [self concernUser:uid inGroups:[NSArray arrayWithObjects:gname, nil]];
    FUNC_END();
    return ret;
}

- (BOOL)concernUser:(int)uid inGroups:(NSArray *)gnames {
    FUNC_START();
    HttpData *data = [[HttpData alloc] init];
    [data setIntValue:self.user.uid forKey:@"uid"];
    [data setIntValue:uid forKey:@"uid1"];
    [data setValue:gnames forKey:@"gnames"];
    NSString *request = [NSString stringWithFormat:@"data=%@",stringToUrlString([data getJsonString])];
    NSMutableDictionary *ret = [httpTransfer syncPost:request to:@"ConcernUser"];
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
    NSMutableDictionary *ret = [httpTransfer syncPost:request to:@"AddConcernlistGroup"];
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
    NSMutableDictionary *ret = [httpTransfer syncPost:request to:@"DeleteConcernlistGroup"];
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
    NSMutableDictionary *ret = [httpTransfer syncPost:request to:@"RenameConcernlistGroup"];
    if (![[ret objectForKey:@"SUC"] boolValue]) {
        LOG(@"renameGroup fail");
        FUNC_END();
        return NO;
    }
    LOG(@"renameGroup succ");

    FUNC_END();
    return YES;
}

+ (BOOL)moveUsers:(NSArray *)users fromGroup:(NSString *)gname toGroups:(NSArray *)gnames {
    FUNC_START();
    HttpData *data = [HttpData data];
    User *user = [RelationshipLogic user];
    [data setIntValue:user.uid forKey:@"uid"];
    [data setValue:users forKey:@"users"];
    [data setValue:gname forKey:@"gname"];
    [data setValue:gnames forKey:@"gnames"];
    NSMutableDictionary *ret = [[HttpTransfer transfer] syncPost:[data getJsonString] to:@"MoveUsersFromGroupToGroups"];
    if (![[ret objectForKey:@"SUC"] boolValue]) {
        LOG(@"MoveUsersFromGroupToGroups fail");
        FUNC_END();
        return NO;
    }
    LOG(@"MoveUsersFromGroupToGroups succ");
    FUNC_END();
    return YES;
}

+ (BOOL)moveUsers:(NSArray *)users fromGroup:(NSString *)gname0 toGroup:(NSString *)gname {
    FUNC_START();
    BOOL ret = [RelationshipLogic moveUsers:users fromGroup:gname0 toGroups:[NSArray arrayWithObjects:gname, nil]];
    FUNC_END();
    return ret;
}

+ (BOOL)moveUser:(int)uid fromGroup:(NSString *)gname toGroups:(NSArray *)gnames {
    FUNC_START();
    BOOL ret = [RelationshipLogic moveUsers:[NSArray arrayWithObjects:[NSNumber numberWithInt:uid], nil] fromGroup:gname toGroups:gnames];
    FUNC_END();
    return ret;
}

+ (BOOL)copyUsers:(NSArray *)users toGroups:(NSArray *)gnames {
    FUNC_START();
    HttpData *data = [HttpData data];
    User *user = [RelationshipLogic user];
    [data setIntValue:user.uid forKey:@"uid"];
    [data setValue:users forKey:@"users"];
    [data setValue:gnames forKey:@"gnames"];
    NSMutableDictionary *ret = [[HttpTransfer transfer] syncPost:[data getJsonString] to:@"CopyUsersToGroups"];
    if (![[ret objectForKey:@"SUC"] boolValue]) {
        LOG(@"CopyUsersToGroups fail");
        FUNC_END();
        return NO;
    }
    LOG(@"CopyUsersToGroups succ");
    FUNC_END();
    return YES;
}

+ (BOOL)copyUsers:(NSArray *)users toGroup:(NSString *)gname {
    FUNC_START();
    BOOL ret = [RelationshipLogic copyUsers:users toGroups:[NSArray arrayWithObjects:gname, nil]];
    FUNC_END();
    return ret;
}

+ (BOOL)copyUser:(int)uid toGroups:(NSArray *)gnames {
    FUNC_START();
    BOOL ret = [RelationshipLogic copyUsers:[NSArray arrayWithObjects:[NSNumber numberWithInt:uid], nil] toGroups:gnames];
    FUNC_END();
    return ret;
}

+ (BOOL)deleteUsers:(NSArray *)users fromGroup:(NSString *)gname {
    FUNC_START();
    HttpData *data = [HttpData data];
    User *user = [RelationshipLogic user];
    [data setIntValue:user.uid forKey:@"uid"];
    [data setValue:users forKey:@"users"];
    [data setValue:gname forKey:@"gname"];
    NSMutableDictionary *ret = [[HttpTransfer transfer] syncPost:[data getJsonString] to:@"DeleteUsersFromGroup"];
    if (![[ret objectForKey:@"SUC"] boolValue]) {
        LOG(@"DeleteUsersFromGroup fail");
        FUNC_END();
        return NO;
    }
    LOG(@"DeleteUsersFromGroup succ");
    FUNC_END();
    return YES;
}

+ (BOOL)deleteUser:(int)uid fromGroup:(NSString *)gname {
    FUNC_START();
    BOOL ret = [RelationshipLogic deleteUsers:[NSArray arrayWithObjects:[NSNumber numberWithInt:uid], nil] fromGroup:gname];
    FUNC_END();
    return ret;
}

- (BOOL)deleteConcernedUser:(int)uid {
    FUNC_START();
    HttpData *data = [HttpData data];
    [data setIntValue:self.user.uid forKey:@"uid"];
    [data setIntValue:uid forKey:@"uid1"];
//    [data setValue:[self getGroupsOfUser:uid] forKey:@"gnames"];
    NSString *request = [NSString stringWithFormat:@"data=%@",stringToUrlString([data getJsonString])];
    NSMutableDictionary *ret = [httpTransfer syncPost:request to:@"DeleteConcernedUser"];
    if (![[ret objectForKey:@"SUC"] boolValue]) {
        LOG(@"DeleteConcernedUser fail");
        FUNC_END();
        return NO;
    }
    LOG(@"DeleteConcernedUser succ");
    FUNC_END();
    return YES;
}

- (BOOL)moveUserToBlacklist:(int)uid {
    FUNC_START();
    BOOL ret = [self moveUsersToBlacklist:[NSArray arrayWithObjects:[NSNumber numberWithInt:uid], nil]];
    FUNC_END();
    return ret;
}

- (BOOL)moveUsersToBlacklist:(NSArray *)users {
    FUNC_START();
    HttpData *data = [HttpData data];
    [data setIntValue:self.user.uid forKey:@"uid"];
    [data setValue:users forKey:@"users"];
    NSString *request = [NSString stringWithFormat:@"data=%@",stringToUrlString([data getJsonString])];
    NSMutableDictionary *ret = [httpTransfer syncPost:request to:@"MoveUsersToBlacklist"];
    if (![[ret objectForKey:@"SUC"] boolValue]) {
        LOG(@"MoveUsersToBlacklist fail");
        FUNC_END();
        return NO;
    }
    LOG(@"MoveUsersToBlacklist succ");
    FUNC_END();
    return YES;
}

- (BOOL)recoverUserFromBlacklist:(int)uid {
    FUNC_START();
    BOOL ret = [self recoverUsersFromBlacklist:[NSArray arrayWithObjects:[NSNumber numberWithInt:uid], nil]];
    FUNC_END();
    return ret;
}

- (BOOL)recoverUsersFromBlacklist:(NSArray *)users {
    FUNC_START();
    HttpData *data = [HttpData data];
    [data setIntValue:self.user.uid forKey:@"uid"];
    [data setValue:users forKey:@"users"];
    NSString *request = [NSString stringWithFormat:@"data=%@",stringToUrlString([data getJsonString])];
    NSMutableDictionary *ret = [httpTransfer syncPost:request to:@"RecoverUsersFromBlacklist"];
    if (![[ret objectForKey:@"SUC"] boolValue]) {
        LOG(@"RecoverUsersFromBlacklist fail");
        FUNC_END();
        return NO;
    }
    LOG(@"RecoverUsersFromBlacklist succ");
    FUNC_END();
    return YES;
}

+ (BOOL)downloadInfo {
    FUNC_START();
    HttpData *data = [HttpData data];//[[HttpData alloc] init];
    User *user = [RelationshipLogic user];
    [data setIntValue:user.uid forKey:@"uid"];
    [data setIntValue:user.relationShip.seq forKey:@"seq"];
    NSMutableDictionary *ret = [[HttpTransfer transfer] syncPost:[data getJsonString] to:@"DownloadRelationshipInfo"];
    if (![[ret objectForKey:@"SUC"] boolValue]) {
        LOG(@"downloadRelationshipInfo fail");
        FUNC_END();
        if ([[ret objectForKey:@"INFO"] isEqualToString:@"newest"])
            return YES;
        return NO;
    }
    LOG(@"downloadRelationshipInfo succ");
    [RelationshipLogic unPackRelationshipInfoData:[ret objectForKey:@"DATA"]];
//    RUN([self print]);
    FUNC_END();
    return YES;
}

+ (BOOL)asyncDownloadInfo {
    FUNC_START();
    HttpData *data = [HttpData data];//[[HttpData alloc] init];
    User *user = [RelationshipLogic user];
    [data setIntValue:user.uid forKey:@"uid"];
    [data setIntValue:user.relationShip.seq forKey:@"seq"];
    BOOL ret = [[HttpTransfer transfer] asyncPost:[data getJsonString] to:@"DownloadRelationshipInfo" withEventName:ASYNC_EVENT_DOWNLOADCONTACT];
    if (!ret) {
        LOG(@"downloadRelationshipInfo fail");
        return NO;
    }
    FUNC_END();
    return YES;

}

+ (NSMutableArray *)downloadFriendsInfo:(NSArray *)users {
    FUNC_START();
    HttpData *data = [HttpData data];
    [data setValue:users forKey:@"uids"];
    NSMutableDictionary *ret = [[HttpTransfer transfer] syncPost:[data getJsonString] to:@"DownloadFriendsInfo"];
    if (![[ret objectForKey:@"SUC"] boolValue]) {
        L(@"failed");
        FUNC_END();
        return nil;
    }
    L(@"succ");
    FUNC_END();
    return [ret objectForKey:@"DATA"];
}

+ (void)unPackRelationshipInfoData:(NSDictionary *)dic {
    User *user = [RelationshipLogic user];
    user.relationShip.seq = [[dic objectForKey:@"seq"] intValue];
    user.relationShip.blackList = [dic objectForKey:@"blacklist"];
    user.relationShip.concerList = [dic objectForKey:@"concernlist"];
    user.relationShip.followList = [dic objectForKey:@"followlist"];
}

//- (NSArray *)getGroupsOfUser:(int)uid {
//    NSMutableArray *array = [[NSMutableArray alloc] init];
//    for (NSDictionary *dic in self.user.relationShip.concerList) {
//        if ([[dic objectForKey:@"userlist"] indexOfObject:[NSNumber numberWithInt:uid]] != NSNotFound)
//            [array addObject:[dic objectForKey:@"gname"]];
//    }
//    return array;
//}

- (void)print {
    NSLog(@"seq: %d",self.user.relationShip.seq);
    NSLog(@"blacklist: %@", [self.user.relationShip.blackList description]);
    NSLog(@"concernlist: %@", [self.user.relationShip.concerList description]);
    NSLog(@"followlist: %@", [self.user.relationShip.followList description]);
}

@end
