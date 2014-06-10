//
//  SearchGoodsViewController.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-6-10.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyActivityIndicatorView;
@interface SearchGoodsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate> {
    NSMutableArray *_data;
    
    UIActivityIndicatorView *_activityIndicator;
    NSMutableSet *_downloadingImages;
    
    int _currentPage;
    int _maxLoadedPage;
    BOOL _isDownload;
    BOOL _backgroundWorking;
    BOOL _downloadFromTop;
    
    NSMutableArray *_gids;
    MyActivityIndicatorView *_myActivityIndicatorView;
}

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIImageView *topBar;

- (IBAction)search:(id)sender;

@end
