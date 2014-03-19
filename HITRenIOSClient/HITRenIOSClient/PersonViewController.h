//
//  PersonViewController.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-3-5.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "MainViewController.h"

@interface PersonViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *_tableCells;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UITableViewCell *headCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *usernameCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *sexCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *birthdayCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *hometownCell;

@property (strong, nonatomic) IBOutlet UITableViewCell *jwcIDCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *jwcPasswordCell;



@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *username;

@property (weak, nonatomic) IBOutlet UILabel *sex;
@property (weak, nonatomic) IBOutlet UILabel *birthday;
@property (weak, nonatomic) IBOutlet UILabel *hometown;

@property (strong, nonatomic) IBOutlet UIImageView *topBar;

@property (nonatomic) BOOL fromRegister;

@end
