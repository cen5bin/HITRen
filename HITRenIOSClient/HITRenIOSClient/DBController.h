//
//  DBController.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-2-24.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBController : NSObject {
    sqlite3 *db;
}

+(DBController *)sharedInstance;



@end
