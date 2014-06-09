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
+ (BOOL)moveUsers:(NSArray *)users fromGroup:(NSString *)gname toGroups:(NSArray *)gnames;
+ (BOOL)moveUsers:(NSArray *)users fromGroup:(NSString *)gname0 toGroup:(NSString *)gname;
+ (BOOL)moveUser:(int)uid fromGroup:(NSString *)gname toGroups:(NSArray *)gnames;
+ (BOOL)copyUsers:(NSArray *)users toGroups:(NSArray *)gnames;
+ (BOOL)copyUsers:(NSArray *)users toGroup:(NSString *)gname;
+ (BOOL)copyUser:(int)uid toGroups:(NSArray *)gnames;
+ (BOOL)deleteUsers:(NSArray *)users fromGroup:(NSString *)gname;
+ (BOOL)deleteUser:(int)uid fromGroup:(NSString *)gname;

+ (BOOL)addGroup:(NSString *)gname;
+ (BOOL)deleteGroup:(NSString *)gname;
- (BOOL)renameGroup:(NSString *)gname1 newName:(NSString *)gname2;
+ (BOOL)deleteConcernedUser:(int)uid;
+ (BOOL)asyncDeleteConcernedUser:(int)uid fromClass:(NSString *)classname;
- (BOOL)moveUserToBlacklist:(int)uid;
- (BOOL)moveUsersToBlacklist:(NSArray *)users;
- (BOOL)recoverUserFromBlacklist:(int)uid;
- (BOOL)recoverUsersFromBlacklist:(NSArray *)users;
+ (BOOL)downloadInfo;
+ (BOOL)asyncDownloadInfofromClass:(NSString *)classname;
+ (NSMutableArray *)downloadFriendsInfo:(NSArray *)users;
+ (void)unPackRelationshipInfoData:(NSDictionary *)dic;
+ (BOOL)uidIsConcerned:(int)uid;
+ (NSString *)gnameOfUid:(int)uid;

@end
