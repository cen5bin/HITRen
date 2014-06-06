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
    _backgroundView.alpha = 0.6;
    [view addSubview:_backgroundView];
    CGRect rect = self.frame;
    rect.origin.y = 200;
    rect.origin.x = CGRectGetWidth(view.frame) - self.frame.size.width/2;
    [view addSubview:self];
}

- (void)hide {
    if (!_backgroundView.superview) return;
    [_backgroundView removeFromSuperview];
    [self removeFromSuperview];
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
