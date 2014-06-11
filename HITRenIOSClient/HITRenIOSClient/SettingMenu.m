//
//  SettingMenu.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-6-11.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "SettingMenu.h"

@implementation SettingMenu

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

- (void)clear {
    UIImage *image = [UIImage imageNamed:@"menu1_0.png"];
    self.imageView.image = image;
}

- (IBAction)exitButtonClicked:(id)sender {
    self.imageView.image = [UIImage imageNamed:@"menu1_1.png"];
    [self.delegate menuDidChooseAtIndex:0];
    [self performSelector:@selector(clear) withObject:nil afterDelay:0.1];
}

@end
