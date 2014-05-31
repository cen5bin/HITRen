//
//  ThingCell.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-31.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThingCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *thingName;
@property (strong, nonatomic) IBOutlet UILabel *releaseTime;
@property (strong, nonatomic) IBOutlet UITextView *thingDescription;
@property (strong, nonatomic) IBOutlet UIImageView *pic;
@property (strong, nonatomic) IBOutlet UILabel *noImageLabel;


@end
