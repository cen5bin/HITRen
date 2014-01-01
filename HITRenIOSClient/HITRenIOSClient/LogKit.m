//
//  Kit.m
//  Test
//
//  Created by wubincen on 13-12-14.
//  Copyright (c) 2013年 wubincen. All rights reserved.
//

#import "LogKit.h"

void functionLog(const char *filename, int line, const char* funcName,NSString *string) {
    NSString *string1 = [[[NSString stringWithUTF8String:filename] componentsSeparatedByString:@"/"] lastObject];
    printf("%s line %d:%s %s\n", [string1 UTF8String], line, funcName, [string UTF8String]);
}

NSString *stringToUrlString(NSString *string) {
    NSString *ret = (NSString *)CFBridgingRelease(
            CFURLCreateStringByAddingPercentEscapes(
            NULL,
            (CFStringRef)string,
            NULL,
            (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
            CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)
            )
        );
    return ret;
}
