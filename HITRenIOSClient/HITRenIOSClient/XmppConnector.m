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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didConnected) name:XMPP_CONNECT_SUCC object:nil];
        _messageQueue = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)loadConfigure {
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"xmppserver" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:filepath];
    serverIP = [data objectForKey:@"serverIP"];
    serverIP = SERVER_IP;
    hostname = [data objectForKey:@"hostname"];
}

- (void)setupStream {
    xmppStream = [[XMPPStream alloc] init];
    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (BOOL)connect {
    if (xmppStream.isConnected || xmppStream.isConnecting) return YES;
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
    [[NSNotificationCenter defaultCenter] postNotificationName:XMPP_CONNECT_SUCC object:nil userInfo:nil];
    [self goOnline];
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
//    [[message elementForName:@"body"] ∂]
    NSString *msg = [[message elementForName:@"body"] stringValue];
    [[NSNotificationCenter defaultCenter] postNotificationName:XMPP_MESSAGE_RECEIVED object:msg];
}

//- (BOOL)sendMessage:(NSString *)message toUid:(int)uid0 {
//    if (!xmppStream.isConnected&&!xmppStream.isConnecting) [self connect];
//    if (!xmppStream.isConnected) {
//        [_messageQueue addObject:@{@"message":message, @"uid":[NSNumber numberWithInt:uid0]}];
//        return NO;
//    }
//    NSMutableDictionary *body = [[NSMutableDictionary alloc] init];
//    [body setObject:[NSNumber numberWithInt:0] forKey:@"type"];
//    NSMutableDictionary *content = [[NSMutableDictionary alloc] init];
//    [content setObject:[NSNumber numberWithInt:self.uid] forKey:@"uid"];
//    [content setObject:message forKey:@"text"];
//    NSDateFormatter *format = [[NSDateFormatter alloc] init];
//    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    [content setObject:[format stringFromDate:[NSDate date]] forKey:@"date"];
//    [body setObject:content forKey:@"content"];
//    NSData *data = [NSJSONSerialization dataWithJSONObject:body options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *jid = [NSString stringWithFormat:@"hitrenuid%d@%@", uid0, hostname];
//    NSXMLElement *m = [NSXMLElement elementWithName:@"message"];
//    [m addAttributeWithName:@"to" stringValue:jid];
//    NSXMLElement *element = [NSXMLElement elementWithName:@"body" stringValue:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
//    [m addChild:element];
//    [xmppStream sendElement:m];
//    return YES;
//}

- (BOOL)sendMessage:(id)message {
    if (!xmppStream.isConnected&&!xmppStream.isConnecting) [self connect];
    if (!xmppStream.isConnected) {
        [_messageQueue addObject:message];
        return NO;
    }
    [xmppStream sendElement:message];
    return YES;
}

- (NSString *)getHostname {
    return hostname;
}

- (void)didConnected {
    while (_messageQueue.count) {
        id message = [_messageQueue objectAtIndex:0];
        if (![self sendMessage:message])
            break;
        [_messageQueue removeObjectAtIndex:0];
    }
}

//- (void)didConnected {
//    while (_messageQueue.count) {
//        NSDictionary *dic = [_messageQueue objectAtIndex:0];
//        if (![self sendMessage:[dic objectForKey:@"message"] toUid:[[dic objectForKey:@"uid"] intValue]]) {
//            [_messageQueue insertObject:[_messageQueue lastObject] atIndex:0];
//            [_messageQueue removeLastObject];
//            break;
//        }
//        [_messageQueue removeObjectAtIndex:0];
//    }
//}

//- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket {
//    L(@"yes123456");
////    CFReadStreamSetProperty([socket readStream], kCFStreamNetworkServiceType, kCFStreamNetworkServiceTypeVoIP);
////    CFWriteStreamSetProperty([socket writeStream], kCFStreamNetworkServiceType, kCFStreamNetworkServiceTypeVoIP);
//    [socket performBlock:^{
//        [socket enableBackgroundingOnSocket];
//    }];
//}

@end
