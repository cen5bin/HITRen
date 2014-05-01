//
//  SendShortMessageViewController.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-4-22.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendShortMessageViewController : UIViewController<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *topBar;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;

@end
