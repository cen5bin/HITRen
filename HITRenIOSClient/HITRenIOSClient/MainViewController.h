//
//  MainViewController.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-2-25.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "BtmToolBar.h"

@interface MainViewController : UIViewController {
    CGRect contentFrame;
    
}

@property (weak, nonatomic) IBOutlet BtmToolBar *btmToolBar;
@property (weak, nonatomic) IBOutlet TopToolBar *topToolBar;

@end