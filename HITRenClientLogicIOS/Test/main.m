//
//  main.m
//  Test
//
//  Created by wubincen on 13-10-17.
//  Copyright (c) 2013年 wubincen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserSimpleLogic.h"
#import "RelationshipLogic.h"
#import "User.h"
int main(int argc, const char * argv[])
{

    @autoreleasepool {
        User *user = [[User alloc] init];
        user.email = @"bin@163.com";
        user.password = @"123";
        RelationShip *relationShip = [[RelationShip alloc] init];
        user.relationShip = relationShip;
        UserSimpleLogic *logic = [[UserSimpleLogic alloc] initWithUser:user];
//        [logic signUp];
        [logic login];
        [logic downloadInfo];
//        logic.user.sex = 1;
//        logic.user.hometown = @"zj";
//        logic.user.birthday = @"asdad";
//        logic.user.seq = 7;
////        [logic updateInfo];
//        [logic downloadInfo];
        RelationshipLogic *logic1 = [[RelationshipLogic alloc] initWithUser:user];
        [logic1 downloadInfo];
//        [logic1 concernUser:<#(int)#> inGroups:<#(NSArray *)#>]
//        [logic1 deleteUsers:[NSArray arrayWithObjects:[NSNumber numberWithInt:2],[NSNumber numberWithInt:1], nil] fromGroup:@"asd"];
//        [logic1 copyUsers:[NSArray arrayWithObjects:[NSNumber numberWithInt:2],[NSNumber numberWithInt:1], nil] toGroup:@"asd"];
//        [logic1 renameGroup:@"你好" newName:@"asd"];
//        [logic1 deleteGroup:@"asd"];
//        [logic1 deleteConcernedUser:33];
//        [logic1 recoverUsersFromBlacklist:[NSArray arrayWithObjects:[NSNumber numberWithInt:2],[NSNumber numberWithInt:10], nil]];
//        [logic1 moveUserToBlacklist:11];
//        [logic1 addGroup:@"你好"];
//        [logic1 deleteGroup:@"你好4"];
//        [logic1 moveUserToBlacklist:33];
        [logic1 recoverUserFromBlacklist:33];
//        [logic1 deleteConcernedUser:33];
//        [logic1 concernUser:33 inGroups:[NSArray arrayWithObjects:@"asd",nil]];
//        [logic1 copyUsers:[NSArray arrayWithObjects:[NSNumber numberWithInt:100],[NSNumber numberWithInt:101], nil] toGroup:@"asd"];
//        [logic1 renameGroup:@"asd1" newName:@"asd"];
//        [logic1 deleteUsers:[NSArray arrayWithObjects:[NSNumber numberWithInt:3], nil] fromGroup:@"default"];
//        [logic1 moveUsers:[NSArray arrayWithObjects:[NSNumber numberWithInt:10],[NSNumber numberWithInt:11], nil] fromGroup:@"default" toGroups:[NSArray arrayWithObjects:@"asd", nil]];
        return 0;
        
//        //第一步，创建URL
//        NSURL *url = [NSURL URLWithString:@"http://localhost:8080/Test/A"];
//        
//        //第二步，通过URL创建网络请求
//        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
//        //NSURLRequest初始化方法第一个参数：请求访问路径，第二个参数：缓存协议，第三个参数：网络请求超时时间（秒）
////        其中缓存协议是个枚举类型包含：
////        NSURLRequestUseProtocolCachePolicy（基础策略）
////        NSURLRequestReloadIgnoringLocalCacheData（忽略本地缓存）
////        NSURLRequestReturnCacheDataElseLoad（首先使用缓存，如果没有本地缓存，才从原地址下载）
////        NSURLRequestReturnCacheDataDontLoad（使用本地缓存，从不下载，如果本地没有缓存，则请求失败，此策略多用于离线操作）
////        NSURLRequestReloadIgnoringLocalAndRemoteCacheData（无视任何缓存策略，无论是本地的还是远程的，总是从原地址重新下载）
////        NSURLRequestReloadRevalidatingCacheData（如果本地缓存是有效的则不下载，其他任何情况都从原地址重新下载）
//        //第三步，连接服务器
//        NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//        
//        NSString *str = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
//        
//        NSLog(@"%@",str);
        NSURL *url = [NSURL URLWithString:@"http://localhost:8080/HITRenServer/Login"];
        //第二步，创建请求
        NSString *post = @"email=cen8bin@163.com&password=123";
//        NSString *asd = @"aaa&aa";
//        asd = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
//        (CFStringRef)asd, NULL,(CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
//        CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
//        NSLog(@"%@",post);
//        post = [NSString stringWithFormat:@"email=%@&password=123",asd];
//        return 0;
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//        [dic setValue:@"123" forKey:@"password"];
//        [dic setValue:@"cen5bin@163.com" forKey:@"email"];
//        NSLog(@"%@",[dic ])
//        postData = [NSJSONSerialization dataWithJSONObject: dic options:NSJSONWritingPrettyPrinted error:nil];
//        NSLog(@"%@",[[NSString alloc] initWithData:postData encoding:NSASCIIStringEncoding]);
        
        NSString *postLength = [NSString stringWithFormat:@"%ld",[postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];        //第三步，连接服务器
        
        NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        NSString *str1 = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@",str1);

        
    }
    return 0;
}

