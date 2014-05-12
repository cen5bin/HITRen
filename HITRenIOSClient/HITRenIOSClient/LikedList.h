//
//  LikedList.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-10.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LikedList : NSManagedObject

@property (nonatomic, retain) NSNumber * mid;
@property (nonatomic, retain) NSNumber * seq;
@property (nonatomic, retain) NSData * list;

@end
