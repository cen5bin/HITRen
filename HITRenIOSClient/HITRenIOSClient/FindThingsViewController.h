//
//  FindThingsViewController.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-31.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuDelegate.h"

@class FindThingsMenu;
@interface FindThingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,MenuDelegate> {
    NSMutableArray *_data;
    FindThingsMenu *_menu;
    UIActivityIndicatorView *_activityIndicator;
    NSMutableSet *_downloadingImages;
    
    
    int _currentPage;
    int _maxLoadedPage;
    BOOL _isDownload;
    BOOL _backgroundWorking;
    BOOL _downloadFromTop;

}

@property (strong, nonatomic) IBOutlet UIImageView *topBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)moreButtonClicked:(id)sender;


@end
