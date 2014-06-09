//
//  RelationshipLogic.h
//  Test
//
//  Created by wubincen on 13-12-20.
//  Copyright (c) 2013年 wubincen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseLogic.h"

@interface RelationshipLogic : BaseLogic

+ (BOOL)concernUser:(int)uid inGroup:(NSString *)gname fromClass:(NSString *)classname;
+ (BOOL)concernUser:(int)uid inGroups:(NSArray *)gnames fromClass:(NSString *)className;
+ (BOOL)moveUsers:(NSArray *)users fromGroup:(NSString *)gname toGroups:(NSArray *)gnames from:(NSString *)classname;
+ (BOOL)moveUsers:(NSArray *)users fromGroup:(NSString *)gname0 toGroup:(NSString *)gname from:(NSString *)classname;
+ (BOOL)moveUser:(int)uid fromGroup:(NSString *)gname toGroups:(NSArray *)gnames from:(NSString *)classname;

+ (BOOL)copyUsers:(NSArray *)users toGroups:(NSArray *)gnames;
+ (BOOL)copyUsers:(NSArray *)users toGroup:(NSString *)gname;
+ (BOOL)copyUser:(int)uid toGroups:(NSArray *)gnames; //弃用
//+ (BOOL)deleteUsers:(NSArray *)users fromGroup:(NSString *)gname;
//+ (BOOL)deleteUser:(int)uid fromGroup:(NSString *)gname;

+ (BOOL)addGroup:(NSString *)gname;
+ (BOOL)deleteGroup:(NSString *)gname;
- (BOOL)renameGroup:(NSString *)gname1 newName:(NSString *)gname2;
+ (BOOL)deleteConcernedUser:(int)uid; //同步
+ (BOOL)asyncDeleteConcernedUser:(int)uid fromClass:(NSString *)classname;
- (BOOL)moveUserToBlacklist:(int)uid;
- (BOOL)moveUsersToBlacklist:(NSArray *)users;
- (BOOL)recoverUserFromBlacklist:(int)uid;
- (BOOL)recoverUsersFromBlacklist:(NSArray *)users;
+ (BOOL)downloadInfo; //弃用
+ (NSMutableArray *)downloadFriendsInfo:(NSArray *)users; //弃用

+ (BOOL)asyncDownloadInfofromClass:(NSString *)classname;

+ (void)unPackRelationshipInfoData:(NSDictionary *)dic;
+ (BOOL)uidIsConcerned:(int)uid;
+ (NSString *)gnameOfUid:(int)uid;

@end
