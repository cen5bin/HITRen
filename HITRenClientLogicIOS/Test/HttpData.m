//
//  HttpData.m
//  Test
//
//  Created by wubincen on 13-12-17.
//  Copyright (c) 2013年 wubincen. All rights reserved.
//

#import "HttpData.h"

@implementation HttpData

+ (id)data {
    HttpData *data = [[HttpData alloc] init] ;
    return data;
}

- (id)init {
    if (self = [super init]) {
        _dic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key {
    [_dic setValue:value forKey:key];
}

- (void)setIntValue:(int)value forKey:(NSString *)key {
    [_dic setValue:[NSNumber numberWithInt:value] forKey:key];
}

- (NSString *)getJsonString {
    NSData *data = [NSJSONSerialization dataWithJSONObject:_dic options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}
@end
