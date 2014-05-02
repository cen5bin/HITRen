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
    
    BOOL _backgroubdLoadData;
    BOOL _backgroubdLoadWorking;
    int _backgroubdLoadDataAtIndex;
    int _maxDataLoadedPage; //最大的加载过数据的页面号，如果拉取过新的timeline，需要将其置为0
    
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
