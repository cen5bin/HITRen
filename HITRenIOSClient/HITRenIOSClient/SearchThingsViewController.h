//
//  SearchThingsViewController.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-6-10.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchThingsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate> {
    NSMutableArray *_data;
//    FindThingsMenu *_menu;
    UIActivityIndicatorView *_activityIndicator;
    NSMutableSet *_downloadingImages;
    
    
    int _currentPage;
    int _maxLoadedPage;
    BOOL _isDownload;
    BOOL _backgroundWorking;
    BOOL _downloadFromTop;
    
    NSMutableArray *_tids;
}

@property (strong, nonatomic) IBOutlet UIImageView *topBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;


@end
