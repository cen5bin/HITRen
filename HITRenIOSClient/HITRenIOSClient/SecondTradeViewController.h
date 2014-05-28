//
//  SecondTradeViewController.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-28.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondTradeViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *_data;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIImageView *topBar;

@end
