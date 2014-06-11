//
//  SettingMenu.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-6-11.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuDelegate.h"

@interface SettingMenu : UIView
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) id <MenuDelegate> delegate;
- (IBAction)exitButtonClicked:(id)sender;

@end
