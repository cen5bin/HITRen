//
//  PersonViewController.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-3-5.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "MainViewController.h"

@class HometownPicker;
@interface PersonViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate> {
    NSMutableArray *_tableCells;
    UIDatePicker *_datePicker;
    HometownPicker *_hometownPicker;
    
    BOOL _hometownChanged;
    BOOL _birthdayChanged;
    BOOL _sexSet;
    BOOL _usernameChanged;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UITableViewCell *headCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *usernameCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *sexCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *birthdayCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *hometownCell;

@property (strong, nonatomic) IBOutlet UITableViewCell *jwcIDCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *jwcPasswordCell;



@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *username;

@property (strong, nonatomic) IBOutlet UIButton *maleButton;
@property (strong, nonatomic) IBOutlet UIButton *femaleButton;


@property (strong, nonatomic) IBOutlet UIButton *birthday;
@property (strong, nonatomic) IBOutlet UIButton *hometown;


@property (strong, nonatomic) IBOutlet UITextField *jwcID;
@property (strong, nonatomic) IBOutlet UITextField *jwcPassword;


@property (strong, nonatomic) IBOutlet UIImageView *topBar;

@property (nonatomic) BOOL fromRegister;

- (IBAction)buttonClicked:(id)sender;

@end
