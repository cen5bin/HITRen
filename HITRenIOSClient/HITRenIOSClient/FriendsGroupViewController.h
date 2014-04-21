//
//  FriendsGroupViewController.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-4-15.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsGroupViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *_groups;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UIImageView *topBar;

@end
