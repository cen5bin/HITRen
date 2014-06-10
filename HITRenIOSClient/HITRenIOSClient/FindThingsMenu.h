//
//  FindThingsMenu.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-31.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuDelegate.h"

@interface FindThingsMenu : UIView

@property (strong, nonatomic) id<MenuDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)releaseInfo:(id)sender;
- (IBAction)searchInfo:(id)sender;
- (IBAction)myThings:(id)sender;

- (IBAction)releaseInfoTouchDown:(id)sender;
- (IBAction)searchInfoTouchDown:(id)sender;
- (IBAction)myThingsTouchDown:(id)sender;

@end
