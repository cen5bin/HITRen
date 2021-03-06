//
//  NoticeObject.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-6.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "NoticeObject.h"

@implementation NoticeObject

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.type = [[aDecoder decodeObjectForKey:@"type"] intValue];
        self.date = [aDecoder decodeObjectForKey:@"date"];
        self.isReply = [[aDecoder decodeObjectForKey:@"isreply"] boolValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.date forKey:@"date"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.type] forKey:@"type"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.isReply] forKey:@"isreply"];
}

- (id)init {
    if (self = [super init]) {
        self.date = [NSDate date];
        self.isReply = NO;
    }
    return self;
}
@end
