//
//  Constant.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-4-9.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#ifndef HITRenIOSClient_Constant_h
#define HITRenIOSClient_Constant_h

#define SERVER_IP @"192.168.1.100"//@"172.17.219.148"

#define PAGE_MESSAGE_COUNT 30 //一页有多少状态
#define TEXTVIEW_WIDTH 290     //状态中的textView宽度
#define TEXTVIEW_HEIGHT 90   //状态中的textView默认高度
#define SHORTMESSAGRCELL_HEIGHT 305 //shortmessage cell 的默认高度
#define LIKEDLISTVIEW_HEIGHT 36 //点赞列表高度
#define COMMENTLISTVIEW_HEIGHT 70 //评论列表的高度
#define COMMENTLISTVIEW_WIDTH 306 //评论列表宽度
#define SHORTMESSAGECELL_BGVIEW_HEIGHT 293 //单元格背景view高度

//一个状态cell中和图片相关的常量
#define SMALLIMAGE_HEIGHT 80 //状态中小图片的高度
#define ONEIMAGE_HEIGHT 240 // 光一张图片时图片的大小
#define TWOIMAGE_HEIGHT 120 //成对图片时图片的大小
#define BETWEEN_IMAGE 5 // 图片间距
#define BOTTOM_HEIGHT 10 //图片的底部空白高度

#define PAGE_ACTIVITY_COUNT 20 // 一页有多少动态消息，点赞之类的

#define PAGE_GOODS_COUNT 20 //一页有多少商品

#define PAGE_THINGS_COUNT 20 // 一页有多少物品

#define PAGE_EVENT_COUNT 20 // 一页多少日程

#define HEADPIC_COUNT 19 //系统头像数量

#define ASYNCDATALOADED @"HITRenAsyncDataFinishedLoading"

#define ASYNC_EVENT_UPDATEUSETINFO @"HITRenAsyncDataUpdataUserInfo"
#define ASYNC_EVENT_SENDSHORTMESSAGE @"HITRenAsyncDataSendShortMessage" //发状态
#define ASYNC_EVENT_DOWNLOADTIMELINE @"HITRenAsyncDataDownloadTimeline" //下载时间线
#define ASYNC_EVENT_DOWNLOADMESSAGES @"HITRenAsyncDataDownloadMessages" //下载状态
#define ASYNC_EVENT_DOWNLOADUSERINFOS @"HITRenAsyncDataDownloadUserInfos" //下载用户基本信息
#define ASYNC_EVENT_LIKEMESSAGE @"HITRenAsyncDataLikeMessage" //点赞
#define ASYNC_EVENT_DOWNLOADLIKEDLIST @"HITRenAsyncDataDownloadLikedList" //下载点赞信息
#define ASYNC_EVENT_COMMENTMESSAGE @"HITRenAsyncDataCommentMessage" //评论
#define ASYNC_EVENT_DOWNLOADCOMMENTLIST @"HITRenAsyncDataDownloadCommentList" //下载评论
#define ASYNC_EVENT_DOWNLOADCONTACT @"HITRenAsyncDataDownloadContact" //下载通讯录

#define ASYNC_EVENT_DOWNLOADIMAGE @"HITRenAsyncDataDownloadImage" //下载图片
#define ASYNC_EVENT_UPLOADIMAGE @"HITRenAsyncDataUploadImage" //上传图片

#define ASYNC_EVENT_UPLOADGOODSINFO @"HITRenAsyncDataUploadGoodsInfo" //上传商品信息
#define ASYNC_EVENT_DOWNLOADGOODSLINE @"HITRenAsyncDataDownloadGoodsLine" //下载商品线
#define ASYNC_EVENT_DOWNLOADMYGOODSLINE @"HITRenAsyncDataDownloadMyGoodsLine" //下载我的商品线
#define ASYNC_EVENT_DOWNLOADGOODSINFO @"HITRenAsyncDataDownloadGoodsInfo" //下载商品数据
#define ASYNC_EVENT_DELETEGOODSINFO @"HITRenAsyncDataDeleteGoods" //删除商品

#define ASYNC_EVENT_UPLOADTHINGSINFO @"HITRenAsyncDataUploadThingsInfo" //上传物品信息
#define ASYNC_EVENT_DOWNLOADTHINGSLINE @"HITRenAsyncDataDownloadThingsLine" //下载物品线
#define ASYNC_EVENT_DOWNLOADMYTHINGSLINE @"HITRenAsyncDataDownloadMyThingsLine" //下载我的物品线
#define ASYNC_EVENT_DOWNLOADTHINGSINFO @"HITRenAsyncDataDownloadThingsInfo" //下载物品数据
#define ASYNC_EVENT_DELETETHINGSINFO @"HITRenAsyncDataDeleteThings" //删除物品


#define ASYNC_EVENT_DOWNLOADEVENTSINFO @"HITRenAsyncDataDownloadEventsInfo" //下载日程信息
#define ASYNC_EVENT_UPLOADEVENT @"HITRenAsyncDataUploadEvent" //上传日程
#define ASYNC_EVENT_DOWNLOADEVENTLINE @"HITRenAsyncDataDownloadEventLine" //下载日程线


#define ASYNC_EVENT_DELETECONCERNEDUSER @"HITRenAsyncDataDeleteConcernedUser" //取消关注
#define ASYNC_EVENT_CONCERNUSER @"HITRenAsyncDataConcernUser" //关注



//////////////////////////////
#define CONCERNEDINFO_CHANGED @"ConcernedInfoChanged"  // 关注、取消关注某人的状态变化


#define XMPP_DATA_RECEIVED @"XMPP_DATA_RECEIVED"
#define XMPP_MESSAGE_RECEIVED @"XMPP_MESSAGE_RECEIVED"
#define XMPP_CONNECT_SUCC @"XMPP_CONNECT_SUCC"
#define XMPP_CHATMESSAGE_RECEIVED @"XMPP_CHATMESSAGE_RECEIVED"

#define BACKGROUND_COLOR [UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1]
#define VIEW_BORDER_COLOR [UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1]

#define BLUE_BUTTON_BACKGROUNF [UIColor colorWithRed:0/255 green:122.0/255 blue:255.0/255 alpha:1]
#define BLUE_BUTTON_BACKGROUNF1 [UIColor colorWithRed:12.0/255 green:89.0/255 blue:173.0/255 alpha:1]
#define GREEN_BUTTON_BACKGROUNF [UIColor colorWithRed:96.0/255 green:210.0/255 blue:48.0/255 alpha:1]
#define GREEN_BUTTON_BACKGROUNF1 [UIColor colorWithRed:81.0/255 green:180.0/255 blue:48.0/255 alpha:1]


#define JPG_COMPRESSIONQUALITY 0.8


#define EMOTION_BEGIN @"[/"
#define EMOTION_END @"]"


#endif
