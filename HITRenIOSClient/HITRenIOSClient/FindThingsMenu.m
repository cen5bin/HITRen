//
//  FindThingsMenu.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-31.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "FindThingsMenu.h"
#import <QuartzCore/QuartzCore.h>

@implementation FindThingsMenu

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

- (IBAction)releaseInfo:(id)sender {
    [self.delegate menuDidChooseAtIndex:0];
    self.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"basemenu0" ofType:@"png"]];
}

- (IBAction)searchInfo:(id)sender {
    [self.delegate menuDidChooseAtIndex:1];
    self.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"basemenu0" ofType:@"png"]];
}

- (IBAction)releaseInfoTouchDown:(id)sender {
    self.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"basemenu1" ofType:@"png"]];
}

- (IBAction)searchInfoTouchDown:(id)sender {
    self.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"basemenu2" ofType:@"png"]];

}
@end
