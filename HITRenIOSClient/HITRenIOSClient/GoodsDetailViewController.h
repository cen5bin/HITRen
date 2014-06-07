//
//  GoodsDetailViewController.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-6-8.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoodsInfo;
@interface GoodsDetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate> {
    NSMutableArray *_cells;
    NSMutableSet *_downloadingImageSet;
}
@property (strong, nonatomic) IBOutlet UIImageView *topBar;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UITableViewCell *nameCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *priceCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *picsCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *descriptionCell;

@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *priceField;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextView *textView;

@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;


@property (strong, nonatomic) GoodsInfo *goodsInfo;

- (IBAction)moreButtonClicked:(id)sender;

@end