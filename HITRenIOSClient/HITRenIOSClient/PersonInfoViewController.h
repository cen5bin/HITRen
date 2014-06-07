//
//  PersonInfoViewController.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-6-7.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserInfo;
@interface PersonInfoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *_cells;
    NSMutableSet *_downloadingImageSet;
    BOOL _choosingGroup;
}
@property (strong, nonatomic) IBOutlet UIImageView *pic;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *topBar;

@property (strong, nonatomic) UserInfo *userInfo;

@property (strong, nonatomic) IBOutlet UITableViewCell *usernameCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *sexCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *birthdayCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *hometownCell;

@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *sexLabel;
@property (strong, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (strong, nonatomic) IBOutlet UILabel *hometownLabel;

@property (strong, nonatomic) IBOutlet UIButton *sendMessageButton;
@property (strong, nonatomic) IBOutlet UIButton *concernButton;

@property (nonatomic) BOOL concerned;
@property (nonatomic) BOOL fromChatView;

- (IBAction)moreButtonClicked:(id)sender;

- (IBAction)buttonTouchDown:(id)sender;

- (IBAction)buttonClicked:(id)sender;

@end
