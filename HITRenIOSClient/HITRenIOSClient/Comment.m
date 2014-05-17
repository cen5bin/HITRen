//
//  Comment.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-17.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "Comment.h"
#import "Message.h"


@implementation Comment

@dynamic list;
@dynamic seq;
@dynamic cid;
@dynamic messageInfo;
@synthesize commentList = _commentList;

- (NSMutableArray *)getCommentList {
    if (_commentList) return _commentList;
    if (self.list) _commentList = [NSKeyedUnarchiver unarchiveObjectWithData:self.list];
    else _commentList = [[NSMutableArray alloc] init];
    return _commentList;
}

- (void)update {
    self.list = [NSKeyedArchiver archivedDataWithRootObject:self.getCommentList];
}


@end
