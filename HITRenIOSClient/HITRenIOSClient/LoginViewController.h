//
//  LoginViewController.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-2-25.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (retain, nonatomic) IBOutlet UITextField *email;
@property (retain, nonatomic) IBOutlet UITextField *password;
- (IBAction)login:(id)sender;

@end
