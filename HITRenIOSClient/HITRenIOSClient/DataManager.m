//
//  DataManager.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-1.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "DataManager.h"
#import "Timeline.h"
#import "Message.h"
#import "Comment.h"
#import "UserInfo.h"

//static NSMutableArray *_messages;
//static Timeline *_timeline;

@implementation DataManager

+ (Timeline *)timeline {
//    if (_timeline) return _timeline;
    FUNC_START();
    NSManagedObjectContext *context = [DBController context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Timeline" inManagedObjectContext:context];
    request.entity = entity;
    NSArray *res = [context executeFetchRequest:request error:nil];
    if (!res || res.count == 0) {
        Timeline *timeline = [NSEntityDescription insertNewObjectForEntityForName:@"Timeline" inManagedObjectContext:context];
        timeline.seq = 0;
        timeline.data = nil;
        [context save:nil];
        FUNC_END();
        return timeline;
    }
    FUNC_END();
    return [res objectAtIndex:0];
}

+ (NSArray *)messagesInPage:(int)page {
    NSManagedObjectContext *context = [DBController context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Message" inManagedObjectContext:context];
    request.entity = entity;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"mid" ascending:NO];
    NSArray *array = [NSArray arrayWithObjects:sortDescriptor, nil];
    request.sortDescriptors = array;
    request.fetchOffset = page * PAGE_MESSAGE_COUNT;
    request.fetchLimit = PAGE_MESSAGE_COUNT;
    NSArray *res = [context executeFetchRequest:request error:nil];
    return res;
}

+ (Message *)getMessage {
    NSManagedObjectContext *context = [DBController context];
    Message *message = [NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:context];
    return message;
}

+ (UserInfo *)getUserInfo {
    NSManagedObjectContext *context = [DBController context];
    UserInfo *userInfo = [NSEntityDescription insertNewObjectForEntityForName:@"UserInfo" inManagedObjectContext:context];
    return userInfo;
}

+ (UserInfo *)getUserInfoOfUid:(int)uid {
    NSManagedObjectContext *context = [DBController context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserInfo" inManagedObjectContext:context];
    request.entity = entity;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %d", uid];
    request.predicate = predicate;
    request.fetchLimit = 1;
    NSArray *array = [context executeFetchRequest:request error:nil];
    if (array && array.count) return [array objectAtIndex:0];
    return nil;
}

+ (void)deleteEntity:(NSManagedObject *)entity {
    NSManagedObjectContext *context = [DBController context];
    [context deleteObject:entity];
}

+ (void)save {
    [[DBController context] save:nil];
}

@end
