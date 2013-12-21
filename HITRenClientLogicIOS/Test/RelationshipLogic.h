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
- (BOOL)addGroup:(NSString *)gname;
- (BOOL)deleteGroup:(NSString *)gname;
@end
