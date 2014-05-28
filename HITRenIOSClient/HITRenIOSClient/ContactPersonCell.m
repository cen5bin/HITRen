//
//  ContactCell.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-28.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "ContactPersonCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation ContactPersonCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)awakeFromNib {
    const CGFloat tmp = 220.0;
    self.contentView.layer.borderColor = [UIColor colorWithRed:tmp/255 green:tmp/255 blue:tmp/255 alpha:1].CGColor;
    self.contentView.layer.borderWidth = 0.5;
}

@end
