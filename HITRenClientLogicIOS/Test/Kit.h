//
//  Kit.h
//  Test
//
//  Created by wubincen on 13-12-14.
//  Copyright (c) 2013年 wubincen. All rights reserved.
//

#import <Foundation/Foundation.h>
#define HITREN_DEBUG

NSString *stringToUrlString(NSString * string);
void functionLog(const char* funcName, NSString *string);

#ifdef HITREN_DEBUG

    #define LOG(x) NSLog(@"%@",x)
    #define FUNC_LOG(x) functionLog(__FUNCTION__, x)
    #define FUNC_START() FUNC_LOG(@"start")
    #define FUNC_END() FUNC_LOG(@"end")

#else

    #define LOG(x) nil
    #define FUNC_LOG(x) nil
    #define FUNC_START() nil
    #define FUNC_END() nil

#endif


