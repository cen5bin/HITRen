//
//  ShortMessageCell.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-4-22.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShortMessageCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *picture;
@property (strong, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIView *bgView;

@end
