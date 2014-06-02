//
//  AppData.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-2.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "AppData.h"
#import "DataManager.h"
#import "Timeline.h"
#import "Message.h"
#import "UserInfo.h"
#import "Notice.h"
#import "NoticeObject.h"
#import "LikedList.h"
#import "Comment.h"
#import "GoodsLine.h"
#import "GoodsInfo.h"
#import "ThingsLine.h"
#import "ThingsInfo.h"
//#import "MessageLogic.h"

static AppData *appData;

@implementation AppData

@synthesize timeline = _timeline;
@synthesize noticeLine = _noticeLine;
@synthesize goodsLine = _goodsLine;
@synthesize thingsLine = _thingsLine;

- (id)init {
    if (self = [super init]) {
        [self loadMessageInPage:0];
//        self.userInfos = [[NSMutableDictionary alloc] init];
        _userInfos = [[NSMutableDictionary alloc] init];
        _notices = [[NSMutableDictionary alloc] init];
        _likedLists = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (id)sharedInstance {
    if (appData) return appData;
    appData = [[AppData alloc] init];
    return appData;
}

+ (void)saveData {
    [DataManager save];
}

+ (Message *)newMessage {
    return [DataManager getMessage];
}

- (NSMutableArray *)getNoticeLine {
    if (_noticeLine) return _noticeLine;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _noticeLine = [[NSMutableArray alloc]initWithArray:[userDefaults objectForKey:@"noticeLine"]];
    if (!_noticeLine) _noticeLine = [[NSMutableArray alloc] init];
    return _noticeLine;
}

- (Timeline*)getTimeline {
    if (_timeline) return _timeline;
    _timeline = [DataManager timeline];
    return _timeline;
}

- (void)loadMessageInPage:(int)page {
    NSArray *messages = [DataManager messagesInPage:page];
    _messages = [[NSMutableDictionary alloc] init];
    for (Message *message in messages) {
        if ([_messages objectForKey:message.mid])
            [DataManager deleteEntity:[_messages objectForKey:message.mid]];
        [_messages setObject:message forKey:message.mid];
    }
}

- (Message *)messgeForId:(int)mid {
    NSNumber *mid0 = [NSNumber numberWithInt:mid];
    Message *message = [_messages objectForKey:mid0];
    if (message == nil) {
        message = [AppData newMessage];
        [_messages setObject:message forKey:mid0];
        message.mid = mid0;
    }
    return message;
}

- (Message *)privateMessageForId:(int)mid {
    
    
    NSNumber *mid0 = [NSNumber numberWithInt:mid];
    return [_messages objectForKey:mid0];
}

- (NSArray *)messagesNeedDownload {
    return [self messagesNeedDownloadFromIndex:0];
}

- (NSArray *)messagesNeedDownloadFromIndex:(int)index {
    [self loadMessageInPage:index / PAGE_MESSAGE_COUNT + 1];
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    int count = self.timeline.mids.count;
    if (index >= count) return nil;
    int count0 = count;
    if (count0 > PAGE_MESSAGE_COUNT) count0 = PAGE_MESSAGE_COUNT;
    for (int i = 0; i < count0 && i + index < count ; i++) {
        if ([DataManager getMessageOfMid:[[self.timeline.mids objectAtIndex:i + index] intValue]]) break;
//        if ([self privateMessageForId:[[self.timeline.mids objectAtIndex:i + index] intValue]]) break;
        [ret addObject:[self.timeline.mids objectAtIndex:i + index]];
    }
    return ret;
}

- (NSArray *)getMessagesInPage:(int)page {
    return [DataManager messagesInPage:page];
}

- (UserInfo *)userInfoForId:(int)uid {
    NSNumber *uid0 = [NSNumber numberWithInt:uid];
    UserInfo *userInfo = [_userInfos objectForKey:uid0];
    if (userInfo) return userInfo;
    userInfo = [DataManager getUserInfo];
    [_userInfos setObject:userInfo forKey:uid0];
    userInfo.uid = uid0;
    return userInfo;
}

- (UserInfo *)readUserInfoForId:(int)uid {
    NSNumber *uid0 = [NSNumber numberWithInt:uid];
    UserInfo *userInfo = [_userInfos objectForKey:uid0];
    if (userInfo) return userInfo;
    userInfo = [DataManager getUserInfoOfUid:uid];
    if (!userInfo) return nil;
    [_userInfos setObject:userInfo forKey:uid0];
    return userInfo;
}

- (Message *)readMessageForId:(int)mid {
    Message *message = [_messages objectForKey:[NSNumber numberWithInt:mid]];
    if (message) return message;
    return [DataManager getMessageOfMid:mid];
}

// 当前需要下载的用户信息，返回所有的uid，传递不确定是否需要下载的uid
- (NSArray *)userInfosNeedDownload:(NSArray *)uids {
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    for (NSNumber *uid in uids) {
        if ([self readUserInfoForId:[uid intValue]]) continue;
        [ret addObject:uid];
    }
    return ret;
}



- (Notice *)newNotice{
    return [DataManager getNotice];
}

- (Notice *)lastNoticeOfUid:(int)uid {
    Notice *notice = [DataManager getLastNoticeOfUid:uid];
    if ([notice full]) {
        int index = [notice.index intValue];
        notice = [self newNotice];
        notice.index = [NSNumber numberWithInt:index+1];
    }
    return notice;
}

- (Notice *)getNoticeOfUid:(int)uid atIndex:(int)index {
    return [DataManager getNoticeOfUid:uid atIndex:index];
}

- (void)addNoticeObject:(NoticeObject *)noticeObject inNotice:(Notice *)notice{
    if ([notice full]) {
        int index = [notice.index intValue];
        notice = [self newNotice];
        notice.index = [NSNumber numberWithInt:index+1];
    }
    [notice addNotice:noticeObject];
}

- (void)addNoticeObject:(NoticeObject *)noticeObject from:(int)uid{
    NSNumber *uid0 = [NSNumber numberWithInt:uid];
    Notice *notice = [_notices objectForKey:uid0];
    if (!notice) {
        notice = [self lastNoticeOfUid:uid];
        [_notices setObject:notice forKey:uid0];
    }
    if ([notice full]) {
        int index = [notice.index intValue];
        notice = [self newNotice];
        notice.index = [NSNumber numberWithInt:index+1];
        notice.uid = uid0;
        [_notices setObject:notice forKey:uid0];
    }
    [notice addNotice:noticeObject];
    [AppData saveData];
    if (uid == 0) return;
    if ([self.noticeLine containsObject:uid0])
        [self.noticeLine removeObject:uid0];
    [self.noticeLine insertObject:uid0 atIndex:0];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.noticeLine forKey:@"noticeLine"];
    [userDefaults synchronize];
}

+ (NSString *)stringOfNoticeObject:(NoticeObject *)noticeObject {
    int type = noticeObject.type;
    NSString *ret = @"";
    if (type == 1) {
        NSDictionary *dic = noticeObject.content;
//        NSString *username = [[dic objectForKey:@"by"] objectForKey:@"name"];
        NSString *message = [[dic objectForKey:@"message"] objectForKey:@"content"];
        NSString *op = @"";
        int type0 = [[dic objectForKey:@"type"] intValue];
        if (type0 == 1) op = @"赞";
        else if (type0 == 2) op = @"评论";
        ret = [NSString stringWithFormat:@"%@了你的状态:\"%@\"", op, message];
    }
    return ret;
}

- (NSString *)lastNoticeStringOfUid:(int)uid {
    Notice *notice = [self lastNoticeOfUid:uid];
    NoticeObject *obj = [notice.notices lastObject];
    return [AppData stringOfNoticeObject:obj];
}

- (Notice *)activitiesAtIndex:(int)index{
    return [DataManager activitiesAtIndex:index];
}

- (NSArray *)likedListNeedDownload:(NSArray *)mids {
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:mids];
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    NSArray *likedLists = [DataManager getLikedList:mids];
    
    for (LikedList *likedList in likedLists) {
        [ret addObject:@{@"mid":likedList.mid, @"seq":likedList.seq}];
        [array removeObject:likedList.mid];
    }
    
    for (NSNumber *mid in array) {
        NSDictionary *dic = @{ @"mid": mid, @"seq":[NSNumber numberWithInteger:0]};
        [ret addObject:dic];
    }
    
    return ret;
}

- (LikedList *)getLikedListOfMid:(int)mid {
    return [DataManager getLikedListOfMid:mid];
}

- (NSArray *)commentListNeedDownload:(NSArray *)mids {
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:mids];
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    NSArray *commentList = [DataManager getCommentList:mids];
    
    for (Comment *comment in commentList) {
        [ret addObject:@{@"mid":comment.cid, @"seq":comment.seq}];
        [array removeObject:comment.cid];
    }
    
    for (NSNumber *mid in array) {
        NSDictionary *dic = @{ @"mid": mid, @"seq":[NSNumber numberWithInteger:0]};
        [ret addObject:dic];
    }
    return ret;
}

- (Comment *)getCommentOfMid:(int)mid {
    return [DataManager getCommentOfMid:mid];
}

- (GoodsLine *)getGoodsLine {
    if (_goodsLine) return _goodsLine;
    _goodsLine = [DataManager goodsLine];
    return _goodsLine;
}

- (ThingsLine *)getThingsLine {
    if (_thingsLine) return _thingsLine;
    _thingsLine = [DataManager thingsLine];
    return _thingsLine;
}


//保存图片
- (void)storeImage:(UIImage *)image withFilename:(NSString *)filename {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray* array = [fm URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *docURL = [array objectAtIndex:0];
    NSURL *imageURL = [docURL URLByAppendingPathComponent:@"images"];
    if (![fm fileExistsAtPath:[imageURL absoluteString]])
        [fm createDirectoryAtURL:imageURL withIntermediateDirectories:YES attributes:nil error:nil];
    NSURL *targetURL = [imageURL URLByAppendingPathComponent:filename];
    [UIImagePNGRepresentation(image) writeToURL:targetURL atomically:YES];
}

//获取图片，如果图片不存在则返回nil
- (UIImage *)getImage:(NSString *)filename {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray* array = [fm URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *docURL = [array objectAtIndex:0];
    NSURL *targetURL = [[docURL URLByAppendingPathComponent:@"images"] URLByAppendingPathComponent:filename];

    return [UIImage imageWithData:[NSData dataWithContentsOfURL:targetURL]];
}

//对图片尺寸进行压缩--
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

- (NSArray *)goodsInfoNeedDownload:(NSArray *)gids {
    NSMutableArray *tmp = [[NSMutableArray alloc] initWithArray:gids];
    NSArray *array = [DataManager getGoodsList:tmp];
    if (!array || !array.count) return gids;
    for (GoodsInfo *gi in array) {
        if ([tmp containsObject:gi.gid]) [tmp removeObject:gi.gid];
    }
    return tmp;
}

- (GoodsInfo *)newGoodsInfo {
    return [DataManager getGoodsInfo];
}

- (GoodsInfo *)getGoodsInfoOfGid:(int)gid {
    return [DataManager getGoodsInfoOfGid:gid];
}

- (NSArray *)thingsInfoNeedDownload:(NSArray *)tids {
    NSMutableArray *tmp = [[NSMutableArray alloc] initWithArray:tids];
    NSArray *array = [DataManager getThingsList:tmp];
    if (!array || !array.count) return tids;
    for (ThingsInfo *ti in array) {
        if ([tmp containsObject:ti.tid]) [tmp removeObject:ti.tid];
    }
    return tmp;
}

- (ThingsInfo *)newThingsInfo {
    return [DataManager getThingsInfo];
}

- (ThingsInfo *)getThingsInfoOfTid:(int)tid {
    return [DataManager getThingsInfoOfTid:tid];
}
@end
