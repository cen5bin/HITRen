//
//  User.h
//  Test
//
//  Created by wubincen on 13-12-13.
//  Copyright (c) 2013年 wubincen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RelationShip.h"

@interface User : NSObject


// 基本信息
@property (retain, nonatomic) NSString *username;
@property (retain, nonatomic) NSString *email;
@property (retain, nonatomic) NSString *password;
@property (assign, nonatomic) int uid;
@property (retain, nonatomic) NSString *signature;
@property (assign, nonatomic) int sex;
@property (retain, nonatomic) NSString *birthday;
@property (retain, nonatomic) NSString *hometown;
@property (assign, nonatomic) int status;
@property (assign, nonatomic) int seq;

//关系
@property (retain, nonatomic) RelationShip *relationShip;

- (void) print;
@end
