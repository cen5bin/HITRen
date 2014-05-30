//
//  UploadGoodsViewController.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-30.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadGoodsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIScrollViewDelegate> {
    NSMutableArray *_cells;
    NSMutableArray *_pics;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *goodsNameCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *goodsPriceCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *goodsPicCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *goodsDescriptionCell;
@property (strong, nonatomic) IBOutlet UIButton *addPicButton;

@property (strong, nonatomic) IBOutlet UITextField *namefield;
@property (strong, nonatomic) IBOutlet UITextField *pricefield;
@property (strong, nonatomic) IBOutlet UITextView *descriptiontextView;


@property (strong, nonatomic) IBOutlet UIImageView *topBar;

- (IBAction)releaseGoods:(id)sender;
- (IBAction)addPic:(id)sender;

@end
