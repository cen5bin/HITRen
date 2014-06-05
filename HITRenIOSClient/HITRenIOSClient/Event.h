//
//  Event.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-6-5.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Event : NSManagedObject {
    NSMutableArray *_remindTimes;
}

@property (nonatomic, retain) NSString * eid;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSData * reminds;
@property (nonatomic, retain) NSString * place;
@property (nonatomic, retain) NSNumber *seq;


@property (nonatomic, strong, getter = getRemindTimes) NSMutableArray *remindTimes;

- (void)update;
@end
