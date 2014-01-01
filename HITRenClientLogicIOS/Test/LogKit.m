//
//  Kit.m
//  Test
//
//  Created by wubincen on 13-12-14.
//  Copyright (c) 2013年 wubincen. All rights reserved.
//

#import "LogKit.h"

void functionLog(const char *filename, int line, const char* funcName,NSString *string) {
    NSLog(@"%s line %d:%s %@", filename, line, funcName, string);
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
