//
//  CalendarViewController.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-3-5.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "MainViewController.h"

@interface CalendarViewController : MainViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate> {
    NSMutableArray *_data;
    int _currentPage;
    int _maxLoadedPage;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIImageView *topBar;

- (IBAction)addCalendar:(id)sender;

@end
