//
//  HttpTransfer.m
//  Test
//
//  Created by wubincen on 13-12-13.
//  Copyright (c) 2013年 wubincen. All rights reserved.
//

#import "HttpTransfer.h"

static NSString *IP = @"127.0.0.1";
static NSString *SERVER_NAME = @"HITRenServer";
static int PORT = 8080;

@implementation HttpTransfer

+ (NSData *)requestServerForNSDataWithGetMethod:(NSString *)requestString AndServletName:(NSString *)servlet {
    NSString *urlString = [NSString stringWithFormat:@"http://%@:%d/%@/%@",IP, PORT, SERVER_NAME, servlet];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [requestString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPBody:data];
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    return received;
}

+ (NSData *)requestServerForNSDataWithPostMethod:(NSString *)requestString AndServletName:(NSString *)servlet {
    NSString *urlString = [NSString stringWithFormat:@"http://%@:%d/%@/%@",IP, PORT, SERVER_NAME, servlet];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [requestString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%ld",[data length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    return received;
}

+ (NSString *)requestServerWithGetMethod:(NSString *)requestString AndServletName:(NSString *)servlet{
    NSData *received = [HttpTransfer requestServerForNSDataWithGetMethod:requestString AndServletName:servlet];
    NSString *str = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    return str;
}

+ (NSString *)requestServerWithPostMethod:(NSString *)requestString AndServletName:(NSString *)servlet {
    NSData *received = [HttpTransfer requestServerForNSDataWithPostMethod:requestString AndServletName:servlet];    NSString *str = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    return str;
}

+ (NSMutableDictionary *) syncGet:(NSString *)string to:(NSString *)servlet {
    NSData *data = [HttpTransfer requestServerForNSDataWithGetMethod:string AndServletName:servlet];
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    return dic;
}

+ (NSMutableDictionary *) syncPost:(NSString *)string to:(NSString *)servlet {
    NSData *data = [HttpTransfer requestServerForNSDataWithPostMethod:string AndServletName:servlet];
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    return dic;
}

@end
