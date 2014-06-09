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
//void functionLog(const char *filename, int line, const char* funcName, NSString *string);


#define HITREN_DEBUG

#define FUNC_INFO ([NSString stringWithFormat:@"<%s:%d> %s: ", [[[[NSString stringWithUTF8String:__FILE__] componentsSeparatedByString:@"/"] lastObject]UTF8String], __LINE__, __FUNCTION__])

#ifdef HITREN_DEBUG
#define _LOG(fmt, args...)  NSLog(fmt, ##args)
#else
#define _LOG(fmt, args...) NULL
#endif

#define L(x) _LOG(@"%@%@",FUNC_INFO,(x))
#define LOG(fmt, args...) _LOG(@"%@"fmt, FUNC_INFO,##args)

#define FUNC_START()  LOG(@"function start")
#define FUNC_END()  LOG(@"function end")


