//
//  SecondHandMenu.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-29.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "SecondHandMenu.h"

@implementation SecondHandMenu

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

- (IBAction)releaseGoods:(id)sender {
    [self.delegate menuDidChooseAtIndex:0];
    self.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"basemenu" ofType:@"png"]];
}

- (IBAction)searchGoods:(id)sender {
    [self.delegate menuDidChooseAtIndex:1];
    self.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"basemenu" ofType:@"png"]];
}

- (IBAction)releaseGoodsTouchDown:(id)sender {
    self.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"basemenu1" ofType:@"png"]];
}

- (IBAction)searchGoodsTouchDown:(id)sender {
    self.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"basemenu2" ofType:@"png"]];
}
@end
