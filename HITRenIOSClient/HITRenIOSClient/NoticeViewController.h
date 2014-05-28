//
//  MessageViewController.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-3-5.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "MainViewController.h"

@class NoticeViewBar,ContactView;
@interface NoticeViewController : MainViewController <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate> {
//    NSMutableArray *_data;
    NSMutableArray *_activies;
    NSMutableArray *_notices;
}

@property (strong, nonatomic) IBOutlet NoticeViewBar *noticeViewBar;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITableView *activityTableView; //系统推送
@property (strong, nonatomic) IBOutlet UITableView *noticeTableView;  //聊天消息
@property (strong, nonatomic) IBOutlet ContactView *contactView; //通讯录


@property (nonatomic) int flag;


//- (IBAction)swipe:(UISwipeGestureRecognizer *)sender;

@end
