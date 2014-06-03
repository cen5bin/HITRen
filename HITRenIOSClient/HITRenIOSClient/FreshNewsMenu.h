//
//  FreshNewsMenu.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-6-3.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuDelegate.h"

@interface FreshNewsMenu : UIView

@property (strong, nonatomic) id<MenuDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)button1TouchUpInside:(id)sender;
- (IBAction)button2TouchUpInside:(id)sender;

- (IBAction)button1TouchDown:(id)sender;
- (IBAction)button2TouchDown:(id)sender;



@end
