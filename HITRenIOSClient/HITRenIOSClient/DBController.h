//
//  DBController.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-1.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DBController : NSObject {
    NSManagedObjectModel *_model;
    NSPersistentStoreCoordinator *_coordinator;
    NSManagedObjectContext *_context;
}

@property (strong, nonatomic, readonly) NSPersistentStoreCoordinator *coordinator;

+ (id)sharedInstance;
+ (id)context;
+ (void)deleteFile;
- (id)init;
@end
