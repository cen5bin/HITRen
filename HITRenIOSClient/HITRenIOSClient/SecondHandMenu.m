//
//  SecondHandMenu.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-29.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "SecondHandMenu.h"
#import <QuartzCore/QuartzCore.h>

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

- (void)awakeFromNib {
//    self.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.layer.shadowOffset = CGSizeMake(1, 1);
//    self.layer.shadowOpacity = 2;
}

- (IBAction)releaseGoods:(id)sender {
    [self.delegate menuDidChooseAtIndex:0];
    self.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"menu3_0" ofType:@"png"]];
}

- (IBAction)searchGoods:(id)sender {
    [self.delegate menuDidChooseAtIndex:1];
    self.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"menu3_0" ofType:@"png"]];
}

- (IBAction)myGoods:(id)sender {
    [self.delegate menuDidChooseAtIndex:2];
    self.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"menu3_0" ofType:@"png"]];
}



- (IBAction)releaseGoodsTouchDown:(id)sender {
    self.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"menu3_1" ofType:@"png"]];
}

- (IBAction)searchGoodsTouchDown:(id)sender {
    self.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"menu3_2" ofType:@"png"]];
}

- (IBAction)myGoodsTouchDown:(id)sender {
    self.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"menu3_3" ofType:@"png"]];
}
@end
