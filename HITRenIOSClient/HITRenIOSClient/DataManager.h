//
//  DataManager.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-1.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBController.h"

@class Timeline, Message;
@interface DataManager : NSObject

+ (Timeline *)timeline;
+ (Message *)getMessage;
+ (void)save;

@end
