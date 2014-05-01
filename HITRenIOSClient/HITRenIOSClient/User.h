//
//  User.h
//  Test
//
//  Created by wubincen on 13-12-13.
//  Copyright (c) 2013年 wubincen. All rights reserved.
//

#import <Foundation/Foundation.h>


@class RelationShip, Timeline;
@interface User : NSObject


// 基本信息
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *password;
@property (assign, nonatomic) int uid;
@property (strong, nonatomic) NSString *signature;
@property (assign, nonatomic) int sex;
@property (strong, nonatomic) NSString *birthday;
@property (strong, nonatomic) NSString *hometown;
@property (assign, nonatomic) int status;
@property (assign, nonatomic) int seq;

//关系
@property (strong, nonatomic) RelationShip *relationShip;
@property (strong, nonatomic) Timeline *timeline;
- (id)init;

- (void) print;
@end
