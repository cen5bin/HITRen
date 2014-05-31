//
//  GoodsInfo.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-30.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface GoodsInfo : NSManagedObject {
    NSMutableArray *_picNames;
}

@property (nonatomic, retain) NSNumber * gid;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSData * pics;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) NSNumber * uid;

@property (nonatomic, retain, getter = getPicNames) NSMutableArray *picNames;

- (void)update;
@end
