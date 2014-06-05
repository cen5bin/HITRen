//
//  EventLine.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-6-5.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface EventLine : NSManagedObject {
    NSMutableArray *_eids;
}

@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) NSNumber * seq;
@property (nonatomic, retain) NSData * list;

@property (nonatomic, retain, getter = getEids) NSMutableArray *eids;


- (void)update;
@end
