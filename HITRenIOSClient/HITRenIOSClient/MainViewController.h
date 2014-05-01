//
//  MainViewController.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-2-25.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuDelegate.h"
//#import "BtmToolBar.h"

@class MenuView;
@interface MainViewController : UIViewController<MenuDelegate> {
    CGRect contentFrame;
    MenuView *_menuView;
}

@property (weak, nonatomic) IBOutlet BtmToolBar *btmToolBar;
@property (weak, nonatomic) IBOutlet TopToolBar *topToolBar;

@end
