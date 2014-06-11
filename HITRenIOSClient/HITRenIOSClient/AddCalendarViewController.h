//
//  AddCalendarViewController.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-6-4.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyActivityIndicatorView;
@interface AddCalendarViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate> {
    NSMutableArray *_cells;
    NSMutableArray *_data;
    NSMutableArray *_times;
    UIDatePicker *_datePicker;
    MyActivityIndicatorView *_myActivityIndicatorView;
}
@property (strong, nonatomic) IBOutlet UIImageView *topBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UITableViewCell *timeCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *placeCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *eventCell;

@property (strong, nonatomic) IBOutlet UITableViewCell *deleteCell;

@property (strong, nonatomic) IBOutlet UITextView *textView;

@property (strong, nonatomic) NSMutableArray *reminds;

@property (strong, nonatomic) IBOutlet UITextField *timeField;
@property (strong, nonatomic) IBOutlet UITextField *placeField;

@property (strong, nonatomic) NSString *eid;

@property (nonatomic) BOOL edit;

- (IBAction)releaseEvent:(id)sender;


@end
