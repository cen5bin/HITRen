//
//  MessageViewController.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-3-5.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "MainViewController.h"

@class NoticeViewBar;
@interface NoticeViewController : MainViewController <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate> {
//    NSMutableArray *_data;
    NSMutableArray *_activies;
    NSMutableArray *_notices;
}

@property (strong, nonatomic) IBOutlet NoticeViewBar *noticeViewBar;
@property (strong, nonatomic) IBOutlet UITableView *activityTableView;
@property (strong, nonatomic) IBOutlet UITableView *noticeTableView;

@property (nonatomic) int flag;


- (IBAction)swipe:(UISwipeGestureRecognizer *)sender;

@end
