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
    NSString *hostname;
    int uid;
    int port;
    NSMutableArray *_messageQueue;
}

@property (nonatomic) int uid;
@property (nonatomic) int port;
@property (strong, nonatomic) NSString *password;

+ (XmppConnector *)sharedInstance;
- (id)init;
- (void)loadConfigure;
- (void)setupStream;
- (BOOL)connect;
- (void)disconnect;
- (void)goOnline;
- (void)goOffline;
- (BOOL)sendMessage:(NSString *)message toUid:(int)uid;

@end
