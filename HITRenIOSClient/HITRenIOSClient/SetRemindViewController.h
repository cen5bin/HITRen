//
//  SetRemindViewController.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-6-4.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetRemindViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *_data;
}

@property (strong, nonatomic) IBOutlet UIImageView *topBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) int selectedIndex;


- (IBAction)confirmed:(id)sender;

@end
