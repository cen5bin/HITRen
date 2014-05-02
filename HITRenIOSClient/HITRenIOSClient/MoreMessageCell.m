//
//  MoreMessageCell.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-2.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "MoreMessageCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation MoreMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    self.bgView.layer.borderWidth = 0.5;
    self.bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
