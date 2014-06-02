//
//  Message.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-2.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "Message.h"
#import "Comment.h"


@implementation Message

@dynamic mid;
@dynamic uid;
@dynamic time;
@dynamic content;
@dynamic likedlist;
@dynamic type;
@dynamic sharedCount;
@dynamic seq;
@dynamic comment;
@dynamic pics;

@synthesize likedList = _likedList;
@synthesize picNames = _picNames;

- (NSMutableArray *)getLikedList {
    if (_likedList) return _likedList;
    if (self.likedlist == nil) {
        _likedList = [[NSMutableArray alloc] init];
        return _likedList;
    }
    _likedList = [NSKeyedUnarchiver unarchiveObjectWithData:self.likedlist];
    return _likedList;
}

- (void)setLikedList:(NSMutableArray *)likedList {
    _likedList = likedList;
    self.likedlist = [NSKeyedArchiver archivedDataWithRootObject:_likedList];
}

- (NSMutableArray *)getPicNames {
    if (_picNames) return _picNames;
    if (self.pics) _picNames = [NSKeyedUnarchiver unarchiveObjectWithData:self.pics];
    else _picNames = [[NSMutableArray alloc] init];
    return _picNames;
}

- (void)update {
    self.pics = [NSKeyedArchiver archivedDataWithRootObject:self.picNames];
}
@end
