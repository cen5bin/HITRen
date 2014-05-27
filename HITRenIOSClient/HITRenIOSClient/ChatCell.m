//
//  ChatCell.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-26.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "ChatCell.h"

#define MAX_BUBBLETEXTVIEW_WIDTH 176
#define MIN_CELL_HEIGHT 56
#define MIN_BUBBLE_HEIGHT 40
#define MARGIN_TEXTVIEW_UP_DOWN 2
#define MIN_TEXTVIEW_HEIGHT 36

@implementation ChatCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
//    self.isReply = YES;
    _bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:!self.isReply? @"bubble1":@"bubble2" ofType:@"png"]];
    _bubbleImageView = [[UIImageView alloc] initWithImage:[_bubble stretchableImageWithLeftCapWidth:30 topCapHeight:35]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)show {
    CGRect rect = self.pic.frame;
    if (self.isReply)
        rect.origin.x = CGRectGetMaxX(self.contentView.frame) - 8 - rect.size.width;
    else
        rect.origin.x = 8;
    self.pic.frame = rect;
    [self makeBubble];
    [self.contentView addSubview:_bubbleImageView];
}
//
- (void)makeBubble {
     _bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:!self.isReply? @"bubble1":@"bubble2" ofType:@"png"]];
    if (_bubbleImageView.superview) [_bubbleImageView removeFromSuperview];
    _bubbleImageView = [[UIImageView alloc] initWithImage:[_bubble stretchableImageWithLeftCapWidth:30 topCapHeight:35]];
//    for (UIView *view in _bubbleImageView.subviews) [view removeFromSuperview];
    UITextView *textView = [[UITextView alloc] init];
    textView.backgroundColor = [UIColor clearColor];
    textView.textColor = [UIColor whiteColor];
    textView.font = [UIFont boldSystemFontOfSize:16];
    textView.text = self.text;

    CGFloat width = [ChatCell calculateWidth:self.text];
    if (width < MAX_BUBBLETEXTVIEW_WIDTH) {
        CGFloat origin_x = self.isReply?CGRectGetMinX(self.pic.frame) - 5 - (width + 20) : CGRectGetMaxX(self.pic.frame)+5;
        _bubbleImageView.frame = CGRectMake(origin_x, self.pic.frame.origin.y, width + 20, MIN_BUBBLE_HEIGHT);
        origin_x = self.isReply?3:15;
        textView.frame = CGRectMake(origin_x, MARGIN_TEXTVIEW_UP_DOWN, width, MIN_TEXTVIEW_HEIGHT);
    }
    else {
        CGFloat height = [ChatCell calculateHeight:self.text];
        CGFloat origin_x = self.isReply?CGRectGetMinX(self.pic.frame) - 5 - (MAX_BUBBLETEXTVIEW_WIDTH + 20) : CGRectGetMaxX(self.pic.frame)+5;
        _bubbleImageView.frame = CGRectMake(origin_x, self.pic.frame.origin.y, MAX_BUBBLETEXTVIEW_WIDTH+20, height + 2 * MARGIN_TEXTVIEW_UP_DOWN);
        origin_x = self.isReply?3:15;
        textView.frame = CGRectMake(origin_x, MARGIN_TEXTVIEW_UP_DOWN, MAX_BUBBLETEXTVIEW_WIDTH, height);
    }
    [_bubbleImageView addSubview:textView];
}

+ (CGFloat)calculateHeight:(NSString *)text {
    CGSize size = [text sizeWithFont:[UIFont boldSystemFontOfSize:16] constrainedToSize:CGSizeMake(MAX_BUBBLETEXTVIEW_WIDTH - 16, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    return size.height + 16;
}

+ (CGFloat)calculateWidth:(NSString *)text {
    CGSize size = [text sizeWithFont:[UIFont boldSystemFontOfSize:16] constrainedToSize:CGSizeMake(FLT_MAX, MIN_TEXTVIEW_HEIGHT) lineBreakMode:NSLineBreakByWordWrapping];
    return size.width + 16;

}

+ (CGFloat)calculateCellHeight:(NSString *)text {
    CGFloat widht = [ChatCell calculateWidth:text];
    if (widht < MAX_BUBBLETEXTVIEW_WIDTH) return MIN_BUBBLE_HEIGHT + 16;
    CGFloat height = [ChatCell calculateHeight:text] + MARGIN_TEXTVIEW_UP_DOWN * 2;
    return height + 16;
}

@end
