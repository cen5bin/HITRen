//
//  NoticeCell.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-6.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) IBOutlet UILabel *lastNotice;
@property (strong, nonatomic) IBOutlet UIImageView *pic;

@end
