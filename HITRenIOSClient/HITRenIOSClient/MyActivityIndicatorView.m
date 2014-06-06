//
//  MyActivityIndicatorView.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-6-6.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "MyActivityIndicatorView.h"
#import <QuartzCore/QuartzCore.h>

@implementation MyActivityIndicatorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    self.layer.cornerRadius = 10;
}

- (void)showInView:(UIView *)view {
    _backgroundView = [[UIView alloc] initWithFrame:view.frame];
    _backgroundView.backgroundColor = [UIColor blackColor];
    _backgroundView.alpha = 0;
    [view addSubview:_backgroundView];
    CGRect rect = self.frame;
    rect.origin.y = CGRectGetMidY(view.frame) - CGRectGetHeight(rect)/2;
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
    return;
//    _backgroundView = [[UIView alloc] initWithFrame:view.frame];
//    _backgroundView.backgroundColor = [UIColor blackColor];
//    _backgroundView.alpha = 0.6;
//    [view addSubview:_backgroundView];
//    CGRect rect = self.frame;
//    rect.origin.y = 200;
//    rect.origin.x = CGRectGetWidth(view.frame) - self.frame.size.width/2;
//    [view addSubview:self];
}

- (void)hide {
    if (!_backgroundView.superview) return;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _backgroundView.alpha = 0;
        self.alpha = 0;
    } completion:^(BOOL finished){
        [_backgroundView removeFromSuperview];
        [self removeFromSuperview];
        
    }];

//    [_backgroundView removeFromSuperview];
//    [self removeFromSuperview];
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
