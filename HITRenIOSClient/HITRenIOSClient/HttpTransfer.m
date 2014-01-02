//
//  HttpTransfer.m
//  Test
//
//  Created by wubincen on 13-12-13.
//  Copyright (c) 2013年 wubincen. All rights reserved.
//

#import "HttpTransfer.h"

static NSString *IP = @"10.9.180.121";//@"127.0.0.1";
static NSString *SERVER_NAME = @"HITRenServer";
static int PORT = 8080;

@implementation HttpTransfer


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.data appendData:data];
//    NSLog(@"data: %@",[data description]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.data = [NSMutableData data];
//    NSLog(@"response: %@", [response description]);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"%@", [error localizedDescription]);
}

- (NSData *)requestServerForNSDataWithGetMethod:(NSString *)requestString AndServletName:(NSString *)servlet {
    NSString *urlString = [NSString stringWithFormat:@"http://%@:%d/%@/%@",IP, PORT, SERVER_NAME, servlet];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [requestString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPBody:data];
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    return received;
}

- (NSData *)requestServerForNSDataWithPostMethod:(NSString *)requestString AndServletName:(NSString *)servlet {
    NSString *urlString = [NSString stringWithFormat:@"http://%@:%d/%@/%@",IP, PORT, SERVER_NAME, servlet];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [requestString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d",[data length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    return received;
}


- (BOOL)asyncRequestServerForNSDataWithGetMethod:(NSString *)requestString AndServletName:(NSString *)servlet {
    NSString *urlString = [NSString stringWithFormat:@"http://%@:%d/%@/%@",IP, PORT, SERVER_NAME, servlet];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [requestString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPBody:data];
    NSURLConnection *connection = [NSURLConnection  connectionWithRequest:request delegate:self];
    return connection != nil;
}

- (BOOL)asyncRequestServerForNSDataWithPostMethod:(NSString *)requestString AndServletName:(NSString *)servlet {
    NSString *urlString = [NSString stringWithFormat:@"http://%@:%d/%@/%@",IP, PORT, SERVER_NAME, servlet];
    NSLog(@"%@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [requestString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%ld",(unsigned long)[data length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    return connection!=nil;
}

- (NSMutableDictionary *) syncGet:(NSString *)string to:(NSString *)servlet {
    NSData *data = [self requestServerForNSDataWithGetMethod:string AndServletName:servlet];
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    return dic;
}

- (NSMutableDictionary *) syncPost:(NSString *)string to:(NSString *)servlet {
    NSData *data = [self requestServerForNSDataWithPostMethod:string AndServletName:servlet];
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    return dic;
}

- (BOOL) asyncPost:(NSString *)string to:(NSString *)servlet {
    NSLog(@"zzz");
    return [self asyncRequestServerForNSDataWithPostMethod:string AndServletName:servlet];
}

- (BOOL) asyncGet:(NSString *)string to:(NSString *)servlet {
    
    return [self asyncRequestServerForNSDataWithGetMethod:string AndServletName:servlet];
}

@end