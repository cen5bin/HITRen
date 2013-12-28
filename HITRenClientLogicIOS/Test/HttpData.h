//
//  HttpData.h
//  Test
//
//  Created by wubincen on 13-12-17.
//  Copyright (c) 2013年 wubincen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpData : NSObject {
    NSMutableDictionary *_dic;
}

+ (id)data;
- (id)init;
- (void)setValue:(id)value forKey:(NSString *)key;
- (void)setIntValue:(int)value forKey:(NSString *)key;
- (NSString *)getJsonString;

@end
