//
//  ContactView.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-28.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyActivityIndicatorView;
@interface ContactView : UITableView <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate> {
    NSMutableArray *_groups;
    NSMutableDictionary *_list;
    NSMutableArray *_datas;
    BOOL _isLoading;
    UIActivityIndicatorView *_activityIndicator;
    MyActivityIndicatorView *_myActivityIndicator;
    NSMutableSet *_downloadingImageSet;
}

@property (strong, nonatomic) UIViewController *parentController; //包含他的父亲viewController
- (void)willLoad;

@end
