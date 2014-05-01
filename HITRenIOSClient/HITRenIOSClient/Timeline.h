//
//  Timeline.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-4-28.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Timeline : NSObject

@property (nonatomic) int seq;
//@property (nonatomic) int useq;
@property (strong, nonatomic) NSMutableArray *mids;
@property (strong, nonatomic) NSMutableDictionary *messagesDic;

- (id)init;

@end
