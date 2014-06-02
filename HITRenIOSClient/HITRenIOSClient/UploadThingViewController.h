//
//  UploadThingViewController.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-6-2.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadThingViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIScrollViewDelegate> {
    NSMutableArray *_cells;
    NSMutableArray *_pics;
    UIActivityIndicatorView *_activityIndicator;
    BOOL _isWorking;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *thingNameCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *thingPicCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *thingDescriptionCell;
@property (strong, nonatomic) IBOutlet UIButton *addPicButton;
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextView *descriptintextView;

@property (strong, nonatomic) IBOutlet UIImageView *topBar;

- (IBAction)releaseThing:(id)sender;
- (IBAction)addPic:(id)sender;

@end
