//
//  ChatViewController.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-26.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardToolBarDelegate.h"

@class UserInfo,KeyboardToolBar;
@interface ChatViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,KeyboardToolBarDelegate,UIScrollViewDelegate> {
    NSMutableArray *_datas;
    KeyboardToolBar *_keyboardToolBar;
    KeyboardToolBar *_keyboardToolBarAtBottom;
    
    BOOL _keyboardToolBarIsDisappearing;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) IBOutlet UIImageView *topBar;

@property (strong, nonatomic) UserInfo *userInfo;

@end
