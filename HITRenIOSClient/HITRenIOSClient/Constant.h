//
//  Constant.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-4-9.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#ifndef HITRenIOSClient_Constant_h
#define HITRenIOSClient_Constant_h

#define SERVER_IP @"192.168.1.126"//@"172.17.219.148"

#define PAGE_MESSAGE_COUNT 30 //一页有多少状态
#define TEXTVIEW_WIDTH 290     //状态中的textView宽度
#define TEXTVIEW_HEIGHT 90   //状态中的textView默认高度
#define SHORTMESSAGRCELL_HEIGHT 280 //shortmessage cell 的默认高度
#define LIKEDLISTVIEW_HEIGHT 36 //点赞列表高度


#define PAGE_ACTIVITY_COUNT 20 // 一页有多少动态消息，点赞之类的

#define ASYNCDATALOADED @"HITRenAsyncDataFinishedLoading"

#define ASYNC_EVENT_UPDATEUSETINFO @"HITRenAsyncDataUpdataUserInfo"
#define ASYNC_EVENT_SENDSHORTMESSAGE @"HITRenAsyncDataSendShortMessage" //发状态
#define ASYNC_EVENT_DOWNLOADTIMELINE @"HITRenAsyncDataDownloadTimeline" //下载时间线
#define ASYNC_EVENT_DOWNLOADMESSAGES @"HITRenAsyncDataDownloadMessages" //下载状态
#define ASYNC_EVENT_DOWNLOADUSERINFOS @"HITRenAsyncDataDownloadUserInfos" //下载用户基本信息
#define ASYNC_EVENT_LIKEMESSAGE @"HITRenAsyncDataLikeMessage" //点赞
#define ASYNC_EVENT_DOWNLOADLIKEDLIST @"HITRenAsyncDataDownloadLikedList" //下载点赞信息



#define XMPP_MESSAGE_RECEIVED @"XMPP_MESSAGE_RECEIVED"

#endif
