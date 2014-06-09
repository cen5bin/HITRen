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
    return [UploadLogic uploadImages:images withExtend:@"png" from:classname];
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
    BOOL ret = [[HttpTransfer transfer] downloadImage:filename from:classname];
    if (!ret) {
        L(@"download image failed");
        return NO;
    }
    return YES;
}
@end
