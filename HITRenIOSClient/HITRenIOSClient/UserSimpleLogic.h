//
//  UserSimpleLogic.h
//  Test
//
//  Created by wubincen on 13-12-13.
//  Copyright (c) 2013年 wubincen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "BaseLogic.h"

@interface UserSimpleLogic : BaseLogic {
    
}


+ (void)loadUserInfo;
+ (BOOL)login;
+ (BOOL)signUp;
+ (BOOL)downloadInfo;
+ (BOOL)updateInfofrom:(NSString *)classname;
+ (BOOL)updateInfoFinished:(NSDictionary*)ret;
+ (BOOL)downloadUseInfos:(NSArray *)uids from:(NSString *)classname;
+ (void)userInfosDidDownload:(NSDictionary *)data;
+ (BOOL)logout;
@end
