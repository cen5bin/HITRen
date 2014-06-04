//
//  AddCalendarViewController.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-6-4.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCalendarViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate> {
    NSMutableArray *_cells;
    
    NSMutableArray *_data;
}
@property (strong, nonatomic) IBOutlet UIImageView *topBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UITableViewCell *timeCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *placeCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *eventCell;

@property (strong, nonatomic) IBOutlet UITextView *textView;

@property (strong, nonatomic) NSMutableArray *reminds;



@end
