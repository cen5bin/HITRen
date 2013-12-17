//
//  UserSimpleLogic.h
//  Test
//
//  Created by wubincen on 13-12-13.
//  Copyright (c) 2013年 wubincen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface UserSimpleLogic : NSObject {
    
}

@property (retain, nonatomic) User *user;

- (id)initWithUser:(User*)user;
- (BOOL)login;
- (BOOL)signUp;
- (BOOL)downloadInfo;
- (BOOL)updateInfo;
@end
