//
//  UploadLogic.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-10.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "BaseLogic.h"

@interface UploadLogic : BaseLogic

+ (BOOL)uploadImages:(NSArray *)images from:(NSString *)classname;
+ (BOOL)downloadImage:(NSString *)filename from:(NSString *)classname;

+ (BOOL)uploadImages:(NSArray *)images withExtend:(NSString *)extend from:(NSString *)classname;

@end
