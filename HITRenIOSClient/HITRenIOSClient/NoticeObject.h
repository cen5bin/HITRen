//
//  NoticeObject.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-6.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoticeObject : NSObject <NSCoding>
@property (strong, nonatomic) NSDate *date;
@property (nonatomic) int type;
@property (strong, nonatomic) NSDictionary *content;

- (id)init;


@end
