//
//  Kit.m
//  Test
//
//  Created by wubincen on 13-12-14.
//  Copyright (c) 2013年 wubincen. All rights reserved.
//

#import "Kit.h"

void functionLog(const char* funcName,NSString *string) {
    NSLog(@"%s line %d:%s %@",__FILE__,__LINE__, funcName, string);
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
