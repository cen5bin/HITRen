//
//  FreshNewsViewController.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-3-4.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FreshNewsViewController : MainViewController<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate> {
    NSMutableArray* _data;
    UIActivityIndicatorView *_activityIndicator;
    BOOL _timelineDownloading;
    int _currentPage;
    BOOL _updateAtTop;
    int _moreMessageCell;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
