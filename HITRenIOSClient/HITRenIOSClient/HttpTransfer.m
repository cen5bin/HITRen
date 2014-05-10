//
//  HttpTransfer.m
//  Test
//
//  Created by wubincen on 13-12-13.
//  Copyright (c) 2013年 wubincen. All rights reserved.
//

#import "HttpTransfer.h"

static NSString *IP = //@"10.9.180.121";
//@"127.0.0.1";
@"192.168.0.93";
//@"192.168.1.115";

static NSString *SERVER_NAME = @"HITRenServer";
static int PORT = 8080;

static NSString *BOUNDARY_STRING = @"AaB03x";
NSString *BOUNDARY;
NSString *END;

static HttpTransfer *transfer;

@implementation HttpTransfer

+ (HttpTransfer *)sharedInstance {
    if (!transfer)
        transfer = [[HttpTransfer alloc] init];
    return transfer;
}

+ (HttpTransfer *)transfer {
    return [[HttpTransfer alloc] init];
}

- (id)init {
    if (self = [super init]) {
        BOUNDARY = [NSString stringWithFormat:@"--%@",BOUNDARY_STRING];
        END = [NSString stringWithFormat:@"%@--",BOUNDARY];
    }
    return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    L(@"finished loading");
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:self.data options:NSJSONReadingMutableLeaves error:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:ASYNCDATALOADED object:_eventName userInfo:dic];
//    [[NSNotificationCenter defaultCenter] po]
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
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[data length]];
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

- (BOOL)asyncPost:(NSString *)string to:(NSString *)servlet withEventName:(NSString *)eventName {
    _eventName = eventName;
    return [self asyncRequestServerForNSDataWithPostMethod:string AndServletName:servlet];
}

- (BOOL) asyncPost:(NSString *)string to:(NSString *)servlet {
    NSLog(@"zzz");
    return [self asyncRequestServerForNSDataWithPostMethod:string AndServletName:servlet];
}

- (BOOL) asyncGet:(NSString *)string to:(NSString *)servlet {
    
    return [self asyncRequestServerForNSDataWithGetMethod:string AndServletName:servlet];
}

- (BOOL)uploadImages:(NSArray*)images to:(NSString *)servlet {
    NSString *urlString = [NSString stringWithFormat:@"http://%@:%d/%@/%@",IP, PORT, SERVER_NAME, servlet];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];//[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    request.URL = url;
    
    NSMutableData *data = [NSMutableData data];
    for (NSDictionary *dic in images) {
        NSMutableString *body = [[NSMutableString alloc] init];
        [body appendFormat:@"%@\r\n", BOUNDARY];
        [body appendFormat:@"Content-Disposition: form-data; name=\"pic\"; filename=\"%@\"\r\n",[dic objectForKey:@"filename"]];
        [body appendFormat:@"Content-Type: image/png\r\n\r\n"];
        NSData *imageData = UIImagePNGRepresentation([dic objectForKey:@"image"]);
        [data appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:imageData];
        [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [data appendData:[END dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",BOUNDARY_STRING];
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [data length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:data];
    [request setHTTPMethod:@"POST"];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    return conn != nil;
}

@end
