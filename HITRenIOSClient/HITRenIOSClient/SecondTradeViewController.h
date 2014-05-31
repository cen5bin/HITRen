//
//  SecondTradeViewController.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-28.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuDelegate.h"

@class SecondHandMenu;
@interface SecondTradeViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, MenuDelegate, UIScrollViewDelegate> {
    NSMutableArray *_data;
    SecondHandMenu *_menu;
    UIActivityIndicatorView *_activityIndicator;
    NSMutableSet *_downloadingImages;
    
    
    int _currentPage;
    int _maxLoadedPage;
    BOOL _isDownload;
    BOOL _backgroundWorking;
    BOOL _downloadFromTop;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIImageView *topBar;

- (IBAction)moreButtonClicked:(id)sender;

@end
