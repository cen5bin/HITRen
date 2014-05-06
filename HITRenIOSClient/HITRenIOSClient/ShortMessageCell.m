//
//  ShortMessageCell.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-4-22.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "ShortMessageCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation ShortMessageCell

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
    CGFloat tmp = 220;
    self.cellBar.layer.borderColor = [UIColor colorWithRed:tmp/255 green:tmp/255 blue:tmp/255 alpha:1].CGColor;
    self.cellBar.layer.borderWidth = self.bgView.layer.borderWidth;
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.liked? @"liked1":@"liked" ofType:@"png"]];
    [self.likedButton setImage:image forState:UIControlStateNormal];
//    self.bgView.layer.shadowOffset = CGSizeMake(-0.5, 0);
//    self.bgView.layer.shadowColor = [UIColor whiteColor].CGColor;
//    self.bgView.layer.shadowOpacity = 0.4;
//    [self.likedButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"liked1" ofType:@"png"]] forState:UIControlStateHighlighted];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)likeMessage:(id)sender {
    self.liked = !self.liked;
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.liked? @"liked1":@"liked" ofType:@"png"]];
    [self.likedButton setImage:image forState:UIControlStateNormal];
    if (self.liked)
        [self.delegate likeMessage:self];
    else [self.delegate dislikeMessage:self];
}

- (IBAction)commentMessage:(id)sender {
    [self.delegate commentMessage:self];
}

- (IBAction)shareMessage:(id)sender {
    [self.delegate shareMessage:self];
}
@end
