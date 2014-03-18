//
//  HttpTransfer.h
//  Test
//
//  Created by wubincen on 13-12-13.
//  Copyright (c) 2013年 wubincen. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HttpTransfer : NSURLConnection<NSURLConnectionDataDelegate>

+ (HttpTransfer *)sharedInstance;

@property (retain, nonatomic) NSMutableData *data;


- (NSMutableDictionary *) syncPost:(NSString *)string to:(NSString *)servlet;
- (NSMutableDictionary *) syncGet:(NSString *)string to:(NSString *)servlet;


- (BOOL) asyncPost:(NSString *)string to:(NSString *)servlet;
- (BOOL) asyncGet:(NSString *)string to:(NSString *)servlet;

- (BOOL)asyncRequestServerForNSDataWithPostMethod:(NSString *)requestString AndServletName:(NSString *)servlet;
- (BOOL)asyncRequestServerForNSDataWithGetMethod:(NSString *)requestString AndServletName:(NSString *)servlet;

@end
