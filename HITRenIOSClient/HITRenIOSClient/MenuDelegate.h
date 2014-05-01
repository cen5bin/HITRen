//
//  MenuDelegate.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-4-21.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MenuDelegate <NSObject>

@optional
- (void)menuDidChooseAtIndex:(int)index;

@end
