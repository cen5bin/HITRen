//
//  UserInfo.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-3.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserInfo : NSManagedObject

@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) NSNumber * sex;
@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSString * hometown;
@property (nonatomic, retain) NSNumber * seq;
@property (nonatomic, retain) NSString *pic;
@end
