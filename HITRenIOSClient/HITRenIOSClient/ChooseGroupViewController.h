//
//  ChooseGroupViewController.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-6-7.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextBoxDelegate.h"
@class MyActivityIndicatorView;
@interface ChooseGroupViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, TextBoxDelegate> {
    NSMutableArray *_data;
    MyActivityIndicatorView *_myActivityIndicator;
//    int _selectedIndex;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIImageView *topBar;

@property (nonatomic) int selectedIndex;

+ (NSString *)choosedGroupName;

@end
