//
//  XmppConnector.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-2-24.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPP.h"

@interface XmppConnector : NSObject<XMPPStreamDelegate> {
    XMPPStream *xmppStream;
    NSString *serverIP;
}

+ (XmppConnector *)sharedInstance;
- (id)init;
- (void)loadConfigure;
- (void)setupStream;
- (BOOL)connect;
//- (void)disconnect;
//- (void)goOnline;
//- (void)goOffline;

@end
