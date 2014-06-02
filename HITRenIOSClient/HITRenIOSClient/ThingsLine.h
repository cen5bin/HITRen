//
//  ThingsLine.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-31.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ThingsLine : NSManagedObject {
    NSMutableArray *_tids;
}

@property (nonatomic, retain) NSData * data;
@property (nonatomic, retain) NSNumber * seq;

@property (nonatomic, retain, getter = getTids) NSMutableArray *tids;

- (void)update;
@end
