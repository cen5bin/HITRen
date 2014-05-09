//
//  AppDelegate.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-1-1.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMPPDataManager;
@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    XMPPDataManager *_xmppDataManager;
}

@property (strong, nonatomic) UIWindow *window;

@end
