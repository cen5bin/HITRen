//
//  FriendInfoViewController.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-4-15.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendInfoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate> {
    NSMutableArray *_cells;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UITableViewCell *mainCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *usernameCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *sexCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *birthdayCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *hometownCell;

@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UIImageView *picture;

@property (strong, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) IBOutlet UILabel *sex;
@property (strong, nonatomic) IBOutlet UILabel *birthday;
@property (strong, nonatomic) IBOutlet UILabel *hometown;

@property (strong, nonatomic) IBOutlet UIImageView *topBar;

@property (strong, nonatomic) NSDictionary *data;
@property (strong, nonatomic) NSString *gname; // 当前选中的这个人是在哪个跟组里选的

@end
