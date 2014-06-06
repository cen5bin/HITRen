//
//  ContactViewController.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-6-6.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContactView;
@interface ContactViewController : UIViewController {
    BOOL _managing;
}

@property (strong, nonatomic) IBOutlet ContactView *contactView;
@property (strong, nonatomic) IBOutlet UIImageView *topBar;
- (IBAction)manageGroup:(id)sender;

@end
