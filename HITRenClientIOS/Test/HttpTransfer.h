//
//  HttpTransfer.h
//  Test
//
//  Created by wubincen on 13-12-13.
//  Copyright (c) 2013年 wubincen. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HttpTransfer : NSObject

+ (NSData *) requestServerForNSDataWithGetMethod:(NSString *)requestString AndServletName:(NSString *)servlet;
+ (NSData *) requestServerForNSDataWithPostMethod:(NSString *)requestString AndServletName:(NSString *)servlet;

+ (NSString *) requestServerWithGetMethod:(NSString *)requestString AndServletName:(NSString *)servlet;
+ (NSString *) requestServerWithPostMethod:(NSString *)requestString AndServletName:(NSString *)servlet;

+ (NSMutableDictionary *) syncPost:(NSString *)string to:(NSString *)servlet;
+ (NSMutableDictionary *) syncGet:(NSString *)string to:(NSString *)servlet;

@end
