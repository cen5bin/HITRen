//
//  ManageGroupViewController.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-6-6.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextBoxDelegate.h"

@class MyActivityIndicatorView;
@interface ManageGroupViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, TextBoxDelegate> {
    NSMutableArray *_data;
    UIActivityIndicatorView *_activityIndicator;
    MyActivityIndicatorView *_myActivityIndicator;
    NSString *_deletingGroup;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIImageView *topBar;

@end
