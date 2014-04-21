//
//  FriendsListViewController.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-4-15.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *_friends;
}
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIImageView *topBar;

@property (strong, nonatomic) NSMutableArray *uids;
@property (strong, nonatomic) NSString *gname;

@end


@interface FriendCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *userame;
@property (strong, nonatomic) IBOutlet UIImageView *picture;
@property (strong, nonatomic) IBOutlet UILabel *sex;


@end
