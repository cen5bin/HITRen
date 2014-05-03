//
//  Constant.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-4-9.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#ifndef HITRenIOSClient_Constant_h
#define HITRenIOSClient_Constant_h

#define PAGE_MESSAGE_COUNT 30 //一页有多少状态
#define TEXTVIEW_WIDTH 290     //状态中的textView宽度
#define TEXTVIEW_HEIGHT 90   //状态中的textView默认高度
#define SHORTMESSAGRCELL_HEIGHT 200 //shortmessage cell 的默认高度

#define ASYNCDATALOADED @"HITRenAsyncDataFinishedLoading"

#define ASYNC_EVENT_UPDATEUSETINFO @"HITRenAsyncDataUpdataUserInfo"
#define ASYNC_EVENT_SENDSHORTMESSAGE @"HITRenAsyncDataSendShortMessage" //发状态
#define ASYNC_EVENT_DOWNLOADTIMELINE @"HITRenAsyncDataDownloadTimeline" //下载时间线
#define ASYNC_EVENT_DOWNLOADMESSAGES @"HITRenAsyncDataDownloadMessages" //下载状态
#define ASYNC_EVENT_DOWNLOADUSERINFOS @"HITRenAsyncDataDownloadUserInfos" //下载用户基本信息
#endif
