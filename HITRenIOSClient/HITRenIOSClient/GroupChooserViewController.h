//
//  GroupChooserViewController.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-4-15.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupChooserViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *_choosedGroups;
}

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *topBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *groups;
@property (nonatomic) int flag;
@property (nonatomic) int uid;
@property (strong, nonatomic) NSString *gname;

@end
