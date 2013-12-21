//
//  BaseLogic.h
//  Test
//
//  Created by wubincen on 13-12-21.
//  Copyright (c) 2013年 wubincen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface BaseLogic : NSObject

@property (retain, nonatomic) User *user;

- (id)initWithUser:(User *)user;
@end
