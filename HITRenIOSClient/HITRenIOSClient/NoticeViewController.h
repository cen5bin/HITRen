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
    
    UILabel *_noDataLabel1;
    UILabel *_noDataLabel2;
    
    NSMutableSet *_downloadingImageSet;
}

@property (strong, nonatomic) IBOutlet NoticeViewBar *noticeViewBar;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITableView *activityTableView; //系统推送
@property (strong, nonatomic) IBOutlet UITableView *noticeTableView;  //聊天消息
@property (strong, nonatomic) IBOutlet ContactView *contactView; //通讯录

@property (strong, nonatomic) IBOutlet UIView *colorView; //小绿条

@property (nonatomic) int flag;

@property (strong, nonatomic) IBOutlet UIButton *activityButton;
@property (strong, nonatomic) IBOutlet UIButton *noticeButton;
@property (strong, nonatomic) IBOutlet UIButton *contactButton;

- (IBAction)activityButtonClicked:(id)sender;
- (IBAction)noticeButtonClicked:(id)sender;
- (IBAction)contactButtonClicked:(id)sender;

//- (IBAction)swipe:(UISwipeGestureRecognizer *)sender;

@end
