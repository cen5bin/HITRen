//
//  KeyboardToolBar.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-13.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "KeyboardToolBar.h"
#import <QuartzCore/QuartzCore.h>

@implementation KeyboardToolBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    self.textView.layer.borderWidth = 1;
    CGFloat tmp = 220.0;
    self.textView.layer.borderColor = [UIColor colorWithRed:tmp / 255 green:tmp / 255 blue:tmp / 255 alpha:1].CGColor;
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)textViewDidChange:(UITextView *)textView {
    CGFloat height = self.textView.frame.size.height;
    CGFloat height1 = self.textView.contentSize.height;
    CGRect rect = self.frame;
    rect.origin.y -= height1 - height;
    rect.size.height += height1 - height;
    self.frame = rect;
    
    rect = self.sendButton.frame;
    rect.origin.y = CGRectGetHeight(self.frame)/2-self.sendButton.frame.size.height/2;
    self.sendButton.frame = rect;
}


- (CGFloat)calculateTextViewHeight:(NSString *)string {
    UIFont *font = [UIFont systemFontOfSize:14];
    CGSize size = [string sizeWithFont:font constrainedToSize:CGSizeMake(self.textView.frame.size.width-5, FLT_MAX)];
    return size.height + 8;
}

- (void)resignFirstResponder {
    self.hidden = YES;
    [self.textView resignFirstResponder];
}

- (void)becomeFirstResponder {
    [self.textView becomeFirstResponder];
}

- (IBAction)send:(id)sender {
    [self.delegate sendText:self.textView.text];
}
@end