//
//  TextBox.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-6-6.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "TextBox.h"
#import <QuartzCore/QuartzCore.h>

@implementation TextBox

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)awakeFromNib {
    self.textView.layer.cornerRadius = 5;
    self.cancelButton.layer.cornerRadius = 5;
    self.confirmButton.layer.cornerRadius = 5;

}

- (void)showInView:(UIView *)view {
    _backgroundView = [[UIView alloc] initWithFrame:view.frame];
    _backgroundView.backgroundColor = [UIColor blackColor];
    _backgroundView.alpha = 0;
    [view addSubview:_backgroundView];
    CGRect rect = self.frame;
    rect.origin.y = 100;
    rect.origin.x = CGRectGetMidX(view.frame) - CGRectGetWidth(rect)/2;
    self.frame = rect;
    self.alpha = 0;
    [view addSubview:self];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 1;
        _backgroundView.alpha = 0.6;
    } completion:^(BOOL finished){
        [self.textView becomeFirstResponder];
    }];
}

- (IBAction)confirm:(id)sender {
    [self.delegate textBox:self buttonClickedAtIndex:0];
//    [self hide];
}

- (IBAction)cancel:(id)sender {
    [self.delegate textBox:self buttonClickedAtIndex:1];
    [self hide];
}

- (void)hide {
    [self.textView resignFirstResponder];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _backgroundView.alpha = 0;
        self.alpha = 0;
    } completion:^(BOOL finished){
        [_backgroundView removeFromSuperview];
        [self removeFromSuperview];
        
    }];

}
@end
