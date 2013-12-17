//
//  Student.h
//  Test
//
//  Created by wubincen on 13-12-15.
//  Copyright (c) 2013年 wubincen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Student : User

@property (retain, nonatomic) NSString *sid;
@property (retain, nonatomic) NSString *spassword;
@property (assign, nonatomic) int major;
@end
