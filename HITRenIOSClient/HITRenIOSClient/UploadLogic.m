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

+ (BOOL)uploadImages:(NSArray *)images {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (UIImage *image in images) {
        NSString *filename = [UploadLogic filename];
        NSDictionary *dic = @{@"filename":filename,@"image":image};
        [[AppData sharedInstance] storeImage:image withFilename:filename];
        [array addObject:dic];
    }
    return [[HttpTransfer transfer] uploadImages:array to:@"UploadImages"];
}


+ (NSString *)filename {
    static int rand = 1;
    User *user = [UploadLogic user];
    int uid = user.uid;
    NSDate *date = [NSDate date];
    double tmp = [date timeIntervalSince1970];
    NSString *string = [NSString stringWithFormat:@"%03d%010d%.0lf.png",rand % 1000,uid, (tmp*100)];
    rand++;
    return string;
}

+ (BOOL)downloadImage:(NSString *)filename {
    HttpData *data = [HttpData data];
    [data setValue:filename forKey:@"filename"];
    BOOL ret = [[HttpTransfer transfer] downloadImage:[data getJsonString]];
    if (!ret) {
        L(@"download image failed");
        return NO;
    }
    return YES;
}
@end
