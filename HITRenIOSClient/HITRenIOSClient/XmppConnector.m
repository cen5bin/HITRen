//
//  XmppConnector.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-2-24.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "XmppConnector.h"
#import "LogKit.h"

static XmppConnector* connector = nil;

@implementation XmppConnector
+ (XmppConnector *)sharedInstance {
    if (!connector)
        connector = [[XmppConnector alloc] init];
    return connector;
}

- (id)init {
    if (self = [super init]) {
        [self setupStream];
        [self loadConfigure];
    }
    return self;
}

- (void)loadConfigure {
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"xmppserver" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:filepath];
    serverIP = [data objectForKey:@"serverIP"];
}

- (void)setupStream {
    xmppStream = [[XMPPStream alloc] init];
    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (BOOL)connect {
    [xmppStream setHostName:serverIP];
    [xmppStream setHostPort:5222];
    [xmppStream setMyJID:[XMPPJID jidWithString:@"hitrenuid35@hitren.com/ios"]];
    if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:nil]) {
        LOG(@"xmpp connect failed");
        return NO;
    }
    return YES;
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    LOG(@"xmpp connect success");
    if (![xmppStream authenticateWithPassword:@"123" error:nil])
        LOG(@"xmpp authenticate failed");
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    LOG(@"xmpp authenticate success");
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    NSString *msg = [[message elementForName:@"body"] stringValue];
    LOG(msg);
}

@end
