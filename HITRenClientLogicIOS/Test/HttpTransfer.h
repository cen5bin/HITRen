//
//  HttpTransfer.h
//  Test
//
//  Created by wubincen on 13-12-13.
//  Copyright (c) 2013年 wubincen. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HttpTransfer : NSURLConnection<NSURLConnectionDataDelegate>//NSURLConnection<NSURLConnectionDelegate, NSURLConnectionDataDelegate, NSURLConnectionDownloadDelegate>

//- (NSData *) requestServerForNSDataWithGetMethod:(NSString *)requestString AndServletName:(NSString *)servlet;
//- (NSData *) requestServerForNSDataWithPostMethod:(NSString *)requestString AndServletName:(NSString *)servlet;

//+ (NSString *) requestServerWithGetMethod:(NSString *)requestString AndServletName:(NSString *)servlet;
//+ (NSString *) requestServerWithPostMethod:(NSString *)requestString AndServletName:(NSString *)servlet;

- (NSMutableDictionary *) syncPost:(NSString *)string to:(NSString *)servlet;
- (NSMutableDictionary *) syncGet:(NSString *)string to:(NSString *)servlet;

- (BOOL)asyncRequestServerForNSDataWithPostMethod:(NSString *)requestString AndServletName:(NSString *)servlet;
- (BOOL)asyncRequestServerForNSDataWithGetMethod:(NSString *)requestString AndServletName:(NSString *)servlet;

@end
