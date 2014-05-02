//
//  DBController.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-1.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "DBController.h"

static DBController* _controller;
static NSManagedObjectContext *_context;
@implementation DBController
@synthesize coordinator = _coordinator;

+ (id)sharedInstance {
    if (_controller) return _controller;
    _controller = [[DBController alloc] init];
    return _controller;
}

+ (id)context {
    if (_context) return _context;
    DBController *controller = [DBController sharedInstance];
    _context = [[NSManagedObjectContext alloc] init];
    [_context setPersistentStoreCoordinator:controller.coordinator];
    return _context;
}

+ (void)deleteFile {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray* array = [fm URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *docURL = [array objectAtIndex:0];
    NSURL *storeURL = [docURL URLByAppendingPathComponent:@"HITRenDB.sqlite"];
    [fm removeItemAtURL:storeURL error:nil];
}

- (id)init {
    if (self = [super init]) {
        _model = [[NSManagedObjectModel alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"HITRenData" withExtension:@"momd"]];
        
        NSFileManager *fm = [NSFileManager defaultManager];
        NSArray* array = [fm URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
        NSURL *docURL = [array objectAtIndex:0];
        
        NSURL *storeURL = [docURL URLByAppendingPathComponent:@"HITRenDB.sqlite"];
        _coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        [_coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:nil];
    }
    return self;
}


@end
