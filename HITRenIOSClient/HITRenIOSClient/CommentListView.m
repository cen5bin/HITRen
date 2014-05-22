//
//  CommentListView.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-18.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "CommentListView.h"

@implementation CommentListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)awakeFromNib {
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self addGestureRecognizer:recognizer];
}

- (void)tapped:(UITapGestureRecognizer *)recognizer {
    CGPoint p = [recognizer locationInView:self];
    NSString *text = self.text;
    NSArray *array = [text componentsSeparatedByString:@"\n"];
    UIFont *font = [UIFont boldSystemFontOfSize:15];
    CGFloat total = 8;
    const CGFloat tmp = 220.0;
    int line = 0;
    for (NSString *string in array) {
        CGSize size = [string sizeWithFont:font constrainedToSize:CGSizeMake(COMMENTLISTVIEW_WIDTH-5, FLT_MAX)];
        total += size.height;
        line++;
        if (p.y > total) continue;
        NSMutableAttributedString *string0 = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        [string0 addAttribute:NSBackgroundColorAttributeName value:[UIColor colorWithRed:tmp/255 green:tmp/255 blue:tmp/255 alpha:1] range:[text rangeOfString:string]];
        [self setAttributedText:string0];
        [self.commentListViewDelegate tappedAtLine:line];
        [self performSelector:@selector(clearBackground) withObject:nil afterDelay:0.1];
        break;
    }
}

- (void)clearBackground {
    NSMutableAttributedString *string0 = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    [string0 addAttribute:NSBackgroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, self.text.length)];
    [self setAttributedText:string0];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
