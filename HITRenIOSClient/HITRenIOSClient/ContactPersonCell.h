//
//  ContactCell.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-28.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactPersonCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *pic;
@property (strong, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) IBOutlet UILabel *stateLabel;

@end
