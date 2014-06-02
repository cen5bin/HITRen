//
//  KeyboardToolBarDelegate.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-13.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KeyboardToolBarDelegate <NSObject>

- (void)sendText:(NSString*)text;
- (void)emotionButtonClicked;

@end
