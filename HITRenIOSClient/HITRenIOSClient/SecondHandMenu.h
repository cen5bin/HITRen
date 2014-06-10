//
//  SecondHandMenu.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-29.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuDelegate.h"

@interface SecondHandMenu : UIView

@property (strong, nonatomic) id<MenuDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;


- (IBAction)releaseGoods:(id)sender;
- (IBAction)searchGoods:(id)sender;
- (IBAction)myGoods:(id)sender;


- (IBAction)releaseGoodsTouchDown:(id)sender;
- (IBAction)searchGoodsTouchDown:(id)sender;
- (IBAction)myGoodsTouchDown:(id)sender;



@end
