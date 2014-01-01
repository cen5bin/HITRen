//
//  TestHttpTransfer.m
//  Test
//
//  Created by wubincen on 14-1-1.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "TestHttpTransfer.h"
#import "HttpTransfer.h"

void testAsyncRequest() {
    HttpTransfer *httpTransfer = [[HttpTransfer alloc] init];
    BOOL ret = [httpTransfer asyncRequestServerForNSDataWithPostMethod:@"asd" AndServletName:@"Login"];
//    BOOL ret = [httpTransfer asyncRequestServerForNSDataWithGetMethod:@"aaaa" AndServletName:@"Login"];
    if (!ret)
        NSLog(@"%s fail", __func__);
    else NSLog(@"zz");
}