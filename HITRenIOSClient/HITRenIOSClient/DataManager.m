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
#import "GoodsLine.h"
#import "ThingsInfo.h"
#import "ThingsLine.h"
#import "EventLine.h"
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

+ (Message *)getMessageOfMid:(int)mid {
    NSManagedObjectContext *context = [DBController context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Message" inManagedObjectContext:context];
    request.entity = entity;
    request.fetchLimit = 1;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mid == %d", mid];
    request.predicate = predicate;
    NSArray *res = [context executeFetchRequest:request error:nil];
    if (res && res.count)
    return [res objectAtIndex:0];
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
    NSString *tmp = [NSString stringWithFormat:@"mid IN %@", string];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mid IN {1,2}"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:tmp];
    request.predicate = predicate;
    NSArray *array = [context executeFetchRequest:request error:nil];
   
    if (array && array.count) return array;//[array lastObject];
    return [NSArray array];
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

+ (NSArray *)getCommentList:(NSArray *)mids {
    NSManagedObjectContext *context = [DBController context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Comment" inManagedObjectContext:context];
    request.entity = entity;
    NSMutableString *string = [[NSMutableString alloc] init];
    [string appendString:@"{"];
    for (int i = 0; i < mids.count; i++) {
        if (i) [string appendString:@","];
        [string appendString:[NSString stringWithFormat:@"%d", [[mids objectAtIndex:i] intValue]]];
    }
    [string appendString:@"}"];
    NSString *tmp = [NSString stringWithFormat:@"cid IN %@", string];
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mid IN {1,2}"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:tmp];
    request.predicate = predicate;
    NSArray *array = [context executeFetchRequest:request error:nil];
    if (array && array.count) return array;//[array lastObject];
    return [NSArray array];
}

+ (Comment *)getCommentOfMid:(int)mid {
    NSManagedObjectContext *context = [DBController context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Comment" inManagedObjectContext:context];
    request.entity = entity;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cid == %d",mid];
    request.predicate = predicate;
    NSArray *array = [context executeFetchRequest:request error:nil];
    if (array && array.count) return [array lastObject];
    Comment *comment = [DataManager getComment];
    comment.cid = [NSNumber numberWithInt:mid];
    return comment;
}

+ (Comment *)getComment {
    NSManagedObjectContext *context = [DBController context];
    Comment *comment = [NSEntityDescription insertNewObjectForEntityForName:@"Comment" inManagedObjectContext:context];
    return comment;
}

+ (GoodsLine *)goodsLine {
    return [DataManager goodsLineOfUid:0];
}

+ (GoodsLine *)goodsLineOfUid:(int)uid {
//    FUNC_START();
    NSManagedObjectContext *context = [DBController context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"GoodsLine" inManagedObjectContext:context];
    request.entity = entity;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %d", uid];
    request.predicate = predicate;
    NSArray *res = [context executeFetchRequest:request error:nil];
    if (!res || res.count == 0) {
        GoodsLine *goodsLine = [NSEntityDescription insertNewObjectForEntityForName:@"GoodsLine" inManagedObjectContext:context];
        goodsLine.seq = 0;
        goodsLine.data = nil;
        goodsLine.uid = [NSNumber numberWithInt:uid];
        [context save:nil];
        FUNC_END();
        return goodsLine;
    }
//    FUNC_END();
    return [res objectAtIndex:0];
}

+ (NSArray *)getGoodsList:(NSArray *)gids {
    NSManagedObjectContext *context = [DBController context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"GoodsInfo" inManagedObjectContext:context];
    request.entity = entity;
    NSMutableString *string = [[NSMutableString alloc] init];
    [string appendString:@"{"];
    for (int i = 0; i < gids.count; i++) {
        if (i) [string appendString:@","];
        [string appendString:[NSString stringWithFormat:@"%d", [[gids objectAtIndex:i] intValue]]];
    }
    [string appendString:@"}"];
    NSString *tmp = [NSString stringWithFormat:@"gid IN %@", string];
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mid IN {1,2}"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:tmp];
    request.predicate = predicate;
    NSArray *array = [context executeFetchRequest:request error:nil];
    if (array && array.count) return array;//[array lastObject];
    return [NSArray array];

}

+ (GoodsInfo *)getGoodsInfo {
    NSManagedObjectContext *context = [DBController context];
    GoodsInfo *goodsInfo = [NSEntityDescription insertNewObjectForEntityForName:@"GoodsInfo" inManagedObjectContext:context];
    return goodsInfo;

}

+ (GoodsInfo *)getGoodsInfoOfGid:(int)gid {
    NSManagedObjectContext *context = [DBController context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"GoodsInfo" inManagedObjectContext:context];
    request.entity = entity;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"gid == %d", gid];
    request.predicate = predicate;
    request.fetchLimit = 1;
    NSArray *array = [context executeFetchRequest:request error:nil];
    if (array && array.count) return [array objectAtIndex:0];
    return nil;
}

+ (ThingsLine *)thingsLine {
    return [DataManager thingsLineOfUid:0];
//    NSManagedObjectContext *context = [DBController context];
//    NSFetchRequest *request = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ThingsLine" inManagedObjectContext:context];
//    request.entity = entity;
//    NSArray *res = [context executeFetchRequest:request error:nil];
//    if (!res || res.count == 0) {
//        ThingsLine *thingsLine = [NSEntityDescription insertNewObjectForEntityForName:@"ThingsLine" inManagedObjectContext:context];
//        thingsLine.seq = 0;
//        thingsLine.data = nil;
//        [context save:nil];
//        return thingsLine;
//    }
//    return [res objectAtIndex:0];
}

+ (ThingsLine *)thingsLineOfUid:(int)uid {
    NSManagedObjectContext *context = [DBController context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ThingsLine" inManagedObjectContext:context];
    request.entity = entity;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %d", uid];
    request.predicate = predicate;
    NSArray *res = [context executeFetchRequest:request error:nil];
    if (!res || res.count == 0) {
        ThingsLine *thingsLine = [NSEntityDescription insertNewObjectForEntityForName:@"ThingsLine" inManagedObjectContext:context];
        thingsLine.seq = 0;
        thingsLine.data = nil;
        thingsLine.uid = [NSNumber numberWithInt:uid];
        [context save:nil];
        return thingsLine;
    }
    return [res objectAtIndex:0];
}

+ (NSArray *)getThingsList:(NSArray *)tids {
    NSManagedObjectContext *context = [DBController context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ThingsInfo" inManagedObjectContext:context];
    request.entity = entity;
    NSMutableString *string = [[NSMutableString alloc] init];
    [string appendString:@"{"];
    for (int i = 0; i < tids.count; i++) {
        if (i) [string appendString:@","];
        [string appendString:[NSString stringWithFormat:@"%d", [[tids objectAtIndex:i] intValue]]];
    }
    [string appendString:@"}"];
    NSString *tmp = [NSString stringWithFormat:@"tid IN %@", string];
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mid IN {1,2}"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:tmp];
    request.predicate = predicate;
    NSArray *array = [context executeFetchRequest:request error:nil];
    if (array && array.count) return array;//[array lastObject];
    return [NSArray array];
}

+ (ThingsInfo *)getThingsInfo {
    NSManagedObjectContext *context = [DBController context];
    ThingsInfo *thingsInfo = [NSEntityDescription insertNewObjectForEntityForName:@"ThingsInfo" inManagedObjectContext:context];
    return thingsInfo;
}

+ (ThingsInfo *)getThingsInfoOfTid:(int)tid {
    NSManagedObjectContext *context = [DBController context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ThingsInfo" inManagedObjectContext:context];
    request.entity = entity;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tid == %d", tid];
    request.predicate = predicate;
    request.fetchLimit = 1;
    NSArray *array = [context executeFetchRequest:request error:nil];
    if (array && array.count) return [array objectAtIndex:0];
    return nil;
}

+ (EventLine *)eventLineOfUid:(int)uid {
    
    NSManagedObjectContext *context = [DBController context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"EventLine" inManagedObjectContext:context];
    request.entity = entity;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %d", uid];
    request.predicate = predicate;
    request.fetchLimit = 1;
    NSArray *res = [context executeFetchRequest:request error:nil];
    if (!res || res.count == 0) {
        EventLine *eventLine = [NSEntityDescription insertNewObjectForEntityForName:@"EventLine" inManagedObjectContext:context];
        eventLine.seq = 0;
        eventLine.list = nil;
        eventLine.uid = [NSNumber numberWithInt:uid];
        [context save:nil];
        
        return eventLine;
    }
    
    return [res objectAtIndex:0];
}

+ (Event *)getEvent {
    NSManagedObjectContext *context = [DBController context];
    Event *event = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:context];
    return event;
}

+ (Event *)getEventOfEid:(NSString *)eid {
    NSManagedObjectContext *context = [DBController context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:context];
    request.entity = entity;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"eid == %@", eid];
    request.predicate = predicate;
    request.fetchLimit = 1;
    NSArray *array = [context executeFetchRequest:request error:nil];
    if (array && array.count) return [array objectAtIndex:0];
    return nil;
}

+ (NSArray *)getEventsInPage:(int)page {
    NSManagedObjectContext *context = [DBController context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:context];
    request.entity = entity;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:NO];
    NSArray *array = [NSArray arrayWithObjects:sortDescriptor, nil];
    request.sortDescriptors = array;
    request.fetchOffset = page * PAGE_EVENT_COUNT;
    request.fetchLimit = PAGE_EVENT_COUNT;
    NSArray *res = [context executeFetchRequest:request error:nil];
    return res;

}

+ (NSArray *)getEvents:(NSArray *)eids {
    NSManagedObjectContext *context = [DBController context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:context];
    request.entity = entity;
    NSMutableString *string = [[NSMutableString alloc] init];
    [string appendString:@"{"];
    for (int i = 0; i < eids.count; i++) {
        if (i) [string appendString:@","];
        [string appendString:[NSString stringWithFormat:@"\"%@\"", [eids objectAtIndex:i]]];
    }
    [string appendString:@"}"];
    NSString *tmp = [NSString stringWithFormat:@"eid IN %@", string];
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mid IN {1,2}"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:tmp];
    request.predicate = predicate;
    NSArray *array = [context executeFetchRequest:request error:nil];
    if (array && array.count) return array;//[array lastObject];
    return [NSArray array];

}

+ (NSArray *)getUserInfos:(NSArray *)uids {
    NSManagedObjectContext *context = [DBController context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserInfo" inManagedObjectContext:context];
    request.entity = entity;
    NSMutableString *string = [[NSMutableString alloc] init];
    [string appendString:@"{"];
    for (int i = 0; i < uids.count; i++) {
        if (i) [string appendString:@","];
        [string appendString:[NSString stringWithFormat:@"%d", [[uids objectAtIndex:i] intValue]]];
    }
    [string appendString:@"}"];
    NSString *tmp = [NSString stringWithFormat:@"uid IN %@", string];
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mid IN {1,2}"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:tmp];
    request.predicate = predicate;
    NSArray *array = [context executeFetchRequest:request error:nil];
    if (array && array.count) return array;//[array lastObject];
    return [NSArray array];

}

+ (void)deleteEntity:(NSManagedObject *)entity {
    NSManagedObjectContext *context = [DBController context];
    [context deleteObject:entity];
}

+ (void)save {
    [[DBController context] save:nil];
}

@end
