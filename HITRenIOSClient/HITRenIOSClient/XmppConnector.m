//
//  XmppConnector.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-2-24.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "XmppConnector.h"
#import "LogKit.h"
#import <CFNetwork/CFNetwork.h>

static XmppConnector* connector = nil;

@implementation XmppConnector
@synthesize uid;
@synthesize port;

+ (XmppConnector *)sharedInstance {
    if (!connector)
        connector = [[XmppConnector alloc] init];
    return connector;
}

- (id)init {
    if (self = [super init]) {
        [self setupStream];
        [self loadConfigure];
        uid = 35;
        port = 5222;
        self.password = @"123";
    }
    return self;
}

- (void)loadConfigure {
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"xmppserver" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:filepath];
    serverIP = [data objectForKey:@"serverIP"];
    serverIP = SERVER_IP;//@"192.168.1.151";
    hostname = [data objectForKey:@"hostname"];
}

- (void)setupStream {
    xmppStream = [[XMPPStream alloc] init];
    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (BOOL)connect {
    port = 5222;
    [xmppStream setHostName:serverIP];
    [xmppStream setHostPort:port];
    NSString *jid = [NSString stringWithFormat:@"hitrenuid%d@%@/ios", uid, hostname];
    [xmppStream setMyJID:[XMPPJID jidWithString:jid]];
    if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:nil]) {
        LOG(@"xmpp connect failed");
        return NO;
    }
    return YES;
}

- (void)disconnect {
    [self goOffline];
    [xmppStream disconnect];
}

- (void)goOffline {
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [xmppStream sendElement:presence];
}

- (void)goOnline {
    XMPPPresence *present = [XMPPPresence presence];
    [xmppStream sendElement:present];
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    LOG(@"xmpp connect success");
    if (![xmppStream authenticateWithPassword:self.password error:nil])
        LOG(@"xmpp authenticate failed");
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    LOG(@"xmpp authenticate success");
    [self goOnline];
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
//    [[message elementForName:@"body"] ∂]
    NSString *msg = [[message elementForName:@"body"] stringValue];
    [[NSNotificationCenter defaultCenter] postNotificationName:XMPP_MESSAGE_RECEIVED object:msg];
}


- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket {
    L(@"yes123456");
//    CFReadStreamSetProperty([socket readStream], kCFStreamNetworkServiceType, kCFStreamNetworkServiceTypeVoIP);
//    CFWriteStreamSetProperty([socket writeStream], kCFStreamNetworkServiceType, kCFStreamNetworkServiceTypeVoIP);
    [socket performBlock:^{
        [socket enableBackgroundingOnSocket];
    }];
}

@end
