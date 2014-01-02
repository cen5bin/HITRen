//
//  ViewController.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-1-1.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
- (IBAction)Login:(id)sender;

@end
