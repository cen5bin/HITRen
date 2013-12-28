//
//  RelationshipLogic.h
//  Test
//
//  Created by wubincen on 13-12-20.
//  Copyright (c) 2013年 wubincen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "BaseLogic.h"

@interface RelationshipLogic : BaseLogic

- (BOOL)concernUser:(int)uid inGroups:(NSArray *)gnames;
- (BOOL)moveUsers:(NSArray *)users fromGroup:(NSString *)gname toGroups:(NSArray *)gnames;
- (BOOL)copyUsers:(NSArray *)users toGroups:(NSArray *)gnames;
- (BOOL)moveUsers:(NSArray *)users fromGroup:(NSString *)gname0 toGroup:(NSString *)gname;
- (BOOL)copyUsers:(NSArray *)users toGroup:(NSString *)gname;
- (BOOL)deleteUsers:(NSArray *)users fromGroup:(NSString *)gname;
- (BOOL)addGroup:(NSString *)gname;
- (BOOL)deleteGroup:(NSString *)gname;
- (BOOL)renameGroup:(NSString *)gname1 newName:(NSString *)gname2;
- (BOOL)deleteConcernedUser:(int)uid;
- (BOOL)downloadInfo;

@end
