//
//  GoodsLine.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-30.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface GoodsLine : NSManagedObject {
    NSMutableArray *_gids;
}

@property (nonatomic, retain) NSData * data;
@property (nonatomic, retain) NSNumber * seq;
@property (nonatomic, retain, getter = getGids) NSMutableArray *gids;

- (void)update;

@end
