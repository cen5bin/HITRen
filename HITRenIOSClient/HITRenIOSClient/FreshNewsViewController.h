//
//  FreshNewsViewController.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-3-4.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageCellDelegate.h"
#import "KeyboardToolBarDelegate.h"

@class KeyboardToolBar;
@interface FreshNewsViewController : MainViewController<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, MessageCellDelegate, KeyboardToolBarDelegate> {
    NSMutableArray* _data;  //存的是message
    NSMutableDictionary* _comments; //存的是评论，每个元素是个dic
    UIActivityIndicatorView *_activityIndicator;
    BOOL _timelineDownloading;
    int _currentPage;
    BOOL _updateAtTop;
    int _moreMessageCell;
    
    BOOL _backgroubdLoadData;
    BOOL _backgroubdLoadWorking;
    int _backgroubdLoadDataAtIndex;
    int _maxDataLoadedPage; //最大的加载过数据的页面号，如果拉取过新的timeline，需要将其置为0
    
    
    
    KeyboardToolBar *_keyboardToolBar;
    int _commentingMid;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
