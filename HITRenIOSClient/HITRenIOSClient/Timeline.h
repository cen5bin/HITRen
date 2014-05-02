//
//  Timeline.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-1.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Timeline : NSManagedObject {
    NSMutableArray *_mids;
}

@property (nonatomic, retain) NSData * data;
@property (nonatomic, retain) NSNumber * seq;
@property (nonatomic, retain, getter = getMids) NSMutableArray *mids;

- (void)update;

@end
