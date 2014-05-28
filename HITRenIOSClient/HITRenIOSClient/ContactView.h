//
//  ContactView.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-28.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactView : UITableView <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate> {
    NSMutableArray *_groups;
    NSMutableDictionary *_list;
    NSMutableArray *_datas;
    BOOL _isLoading;
    UIActivityIndicatorView *_activityIndicator;
}

- (void)willLoad;

@end
