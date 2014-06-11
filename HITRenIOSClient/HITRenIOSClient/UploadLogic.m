//
//  UploadLogic.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-10.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "UploadLogic.h"
#import "User.h"
#import "HttpData.h"
#import "AppData.h"

static NSString *IP = //@"10.9.180.121";
//@"127.0.0.1";
//@"192.168.0.93";
//@"192.168.1.151";
SERVER_IP;

static NSString *SERVER_NAME = @"HITRenServer";
static int PORT = 8080;

static NSMutableArray *imageQueue;

@implementation UploadLogic

+ (BOOL)uploadImages:(NSArray *)images withExtend:(NSString *)extend from:(NSString *)classname {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (UIImage *image in images) {
        NSString *filename = [UploadLogic filename:extend];
        NSDictionary *dic = @{@"filename":filename,@"image":image};
        [[AppData sharedInstance] storeImage:image withFilename:filename];
        [array addObject:dic];
    }
    return [[HttpTransfer transfer] uploadImages:array to:@"UploadImages" from:(NSString *)classname];
}

+ (BOOL)uploadImages:(NSArray *)images from:(NSString *)classname{
    return [UploadLogic uploadImages:images withExtend:@"jpg" from:classname];
}


+ (NSString *)filename:(NSString *)extend {
    static int rand = 1;
    User *user = [UploadLogic user];
    int uid = user.uid;
    NSDate *date = [NSDate date];
    double tmp = [date timeIntervalSince1970];
    NSString *string = [NSString stringWithFormat:@"%03d%010d%.0lf.%@",rand % 1000,uid, (tmp*100),extend];
    rand++;
    return string;
}

+ (BOOL)downloadImage:(NSString *)filename from:(NSString *)classname{
//    static BOOL working = NO;
//    @synchronized(self) {
//    if (!imageQueue) imageQueue = [[NSMutableArray alloc] init];
//    if (![imageQueue containsObject:filename]) [imageQueue addObject:filename];
//    if (working) return YES;
//        
//    LOG(@"filename %@", filename);
//    L([imageQueue description]);
//    working = YES;
//    }
////    L(@"aaaa");
//    NSString *tmp = [NSString stringWithFormat:@"http://%@:%d/%@/%@?filename=",IP, PORT, SERVER_NAME, @"DownloadImage"];
////    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%d/%@/%@?filename=%@",IP, PORT, SERVER_NAME, @"DownloadImage",filename]];
//    NSString *notificationName = [NSString stringWithFormat:@"%@_%@", ASYNCDATALOADED, classname];
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(queue, ^{
//        while (imageQueue.count) {
//            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", tmp, [imageQueue objectAtIndex:0]]];
////            L([url description]);
////            LOG(@"url %@", <#args...#>)
//            [imageQueue removeObjectAtIndex:0];
//            LOG(@"image queue %@", [imageQueue description]);
//            NSData *data = [NSData dataWithContentsOfURL:url];
////            L([data description]);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSDictionary *dic = @{@"imagedata": data,@"imagename":filename};
//                [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:ASYNC_EVENT_DOWNLOADIMAGE userInfo:dic];
//            });
//        }
//        working = NO;
//    });
//    return YES;
    BOOL ret = [[HttpTransfer transfer] downloadImage:filename from:classname];
    if (!ret) {
        L(@"download image failed");
        return NO;
    }
    return YES;
}
@end
