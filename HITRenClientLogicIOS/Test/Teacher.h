//
//  Teacher.h
//  Test
//
//  Created by wubincen on 13-12-15.
//  Copyright (c) 2013年 wubincen. All rights reserved.
//

#import "User.h"

@interface Teacher : User

@property (retain, nonatomic) NSString *realName;
@property (retain, nonatomic) NSString *telephone;
@property (assign, nonatomic) int major;

@end
