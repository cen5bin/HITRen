//
//  UploadGoodsViewController.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-30.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadGoodsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *_cells;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *goodsNameCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *goodsPriceCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *goodsPicCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *goodsDescriptionCell;


@property (strong, nonatomic) IBOutlet UIImageView *topBar;

@end
