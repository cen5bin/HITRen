//
//  DBController.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-2-24.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "DBController.h"
#import "LogKit.h"

static DBController *controller = nil;

@implementation DBController

+ (DBController *)sharedInstance {
    if (!controller)
        controller = [[DBController alloc] init];
    return controller;
}


- (id)init {
    if (self = [super init]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *document = [paths objectAtIndex:0];
        NSString *dbpath = [document stringByAppendingPathComponent:@"localdb.sqlite"];
        if (sqlite3_open([dbpath UTF8String], &db) != SQLITE_OK) {
            LOG(@"打开数据库失败");
            sqlite3_close(db);
        }
        [self createTables];
    }
    return self;
}

- (BOOL)createTables {
    NSMutableDictionary *tablesDic = [[NSMutableDictionary alloc] init];
    [tablesDic setObject:@"create table if not exists User(uid int primary key, data)" forKey:@"User"];
    for (NSString *key in [tablesDic allKeys])
        if (sqlite3_exec(db, [[tablesDic objectForKey:key] UTF8String], NULL, NULL, NULL) != SQLITE_OK) {
            NSString *string = [NSString stringWithFormat:@"创建%@表失败", key];
            L(string);
            return NO;
        }
//    if (sqlite3_exec(db, "drop table User;", NULL, NULL, NULL) != SQLITE_OK) {
//        LOG(@"创建User表失败");
//        return NO;
//    }
    return YES;
}

@end
