//
//  ToolsViewController.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-3-5.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "MainViewController.h"

@interface ToolsViewController : MainViewController <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *_data;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

// section 0
@property (strong, nonatomic) IBOutlet UITableViewCell *secondHandCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *lookForCell;


@end
