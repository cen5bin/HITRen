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
#import "Notice.h"
#import "LikedList.h"

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

+ (Notice *)getNoticeOfUid:(int)uid atIndex:(int)index {
    NSManagedObjectContext *context = [DBController context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Notice" inManagedObjectContext:context];
    request.entity = entity;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %d and index = %d", uid, index];
    request.predicate = predicate;
    request.fetchLimit = 1;
    NSArray *array = [context executeFetchRequest:request error:nil];
    if (array && array.count) return [array objectAtIndex:0];
    return nil;
}

+ (Notice *)getNotice {
    NSManagedObjectContext *context = [DBController context];
    Notice *notice = [NSEntityDescription insertNewObjectForEntityForName:@"Notice" inManagedObjectContext:context];
    return notice;
}

+ (Notice *)getLastNoticeOfUid:(int)uid {
    NSManagedObjectContext *context = [DBController context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Notice" inManagedObjectContext:context];
    request.entity = entity;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:NO];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %d", uid];
    request.predicate = predicate;
    request.fetchLimit = 1;
    request.sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *array = [context executeFetchRequest:request error:nil];
    if (array && array.count) return [array objectAtIndex:0];
    Notice *notice = [DataManager getNotice];
    notice.index = [NSNumber numberWithInt:1];
    notice.uid = [NSNumber numberWithInt:uid];
    return notice;
}

+ (Notice *)activitiesAtIndex:(int)index {
    NSManagedObjectContext *context = [DBController context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Notice" inManagedObjectContext:context];
    request.entity = entity;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:NO];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == 0"];
    request.predicate = predicate;
    request.fetchLimit = index + 1;
    request.sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *array = [context executeFetchRequest:request error:nil];
    if (array && array.count) return [array lastObject];
    return nil;
}

+ (NSArray *)getLikedList:(NSArray *)mids {
    NSManagedObjectContext *context = [DBController context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LikedList" inManagedObjectContext:context];
    request.entity = entity;
    NSMutableString *string = [[NSMutableString alloc] init];
    [string appendString:@"{"];
    for (int i = 0; i < mids.count; i++) {
        if (i) [string appendString:@","];
        [string appendString:[NSString stringWithFormat:@"%d", [[mids objectAtIndex:i] intValue]]];
    }
    [string appendString:@"}"];
    L(string);
    NSString *tmp = [NSString stringWithFormat:@"mid IN %@", string];
    L(tmp);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mid IN {1,2}"];
    request.predicate = predicate;
    NSArray *array = [context executeFetchRequest:request error:nil];
    if (array && array.count) return [array lastObject];
    return nil;

}

+ (LikedList *)getLikedList {
    NSManagedObjectContext *context = [DBController context];
    LikedList *likedList = [NSEntityDescription insertNewObjectForEntityForName:@"LikedList" inManagedObjectContext:context];
    return likedList;
}

+ (LikedList *)getLikedListOfMid:(int)mid {
    NSManagedObjectContext *context = [DBController context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LikedList" inManagedObjectContext:context];
    request.entity = entity;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mid == %d",mid];
    request.predicate = predicate;
    NSArray *array = [context executeFetchRequest:request error:nil];
    if (array && array.count) return [array lastObject];
    LikedList *likedList = [DataManager getLikedList];
    likedList.mid = [NSNumber numberWithInt:mid];
    return likedList;

}

+ (void)deleteEntity:(NSManagedObject *)entity {
    NSManagedObjectContext *context = [DBController context];
    [context deleteObject:entity];
}

+ (void)save {
    [[DBController context] save:nil];
}

@end
