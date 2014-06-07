//
//  WriterInfoView.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-6-7.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "WriterInfoView.h"
#import "UserInfo.h"
#import <QuartzCore/QuartzCore.h>

@implementation WriterInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    
    self.concernButton.layer.cornerRadius = 5;
    self.sendMessageButton.layer.cornerRadius = 5;
    
}


- (void)showInView:(UIView *)view {
//    view.userInteractionEnabled = NO;
    self.usernameLabel.text = self.userInfo.username;
    _backgroundView = [[UIView alloc] initWithFrame:view.frame];
    _backgroundView.backgroundColor = [UIColor blackColor];
    _backgroundView.alpha = 0;
    [view addSubview:_backgroundView];
    CGRect rect = self.frame;
    rect.origin.y = 150;
    rect.origin.x = CGRectGetMidX(view.frame) - CGRectGetWidth(rect)/2;
    self.frame = rect;
    self.alpha = 0;
    [view addSubview:self];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 1;
        _backgroundView.alpha = 0.6;
    } completion:^(BOOL finished){
//        [self.textView becomeFirstResponder];
    }];

}



- (void)hide {
    if (!_backgroundView.superview) return;
//    _backgroundView.superview.userInteractionEnabled = YES;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _backgroundView.alpha = 0;
        self.alpha = 0;
    } completion:^(BOOL finished){
        [_backgroundView removeFromSuperview];
        [self removeFromSuperview];
        
    }];
}

- (IBAction)buttonClicked:(id)sender {
    L(@"yes");
    if (sender == self.concernButton) [self.delegate writeInfo:self buttonClickedAtIndex:0];
    else if (sender == self.sendMessageButton) [self.delegate writeInfo:self buttonClickedAtIndex:1];
}
@end
