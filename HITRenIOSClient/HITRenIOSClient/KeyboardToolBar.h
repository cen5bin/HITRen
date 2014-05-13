//
//  KeyboardToolBar.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-13.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardToolBarDelegate.h"

@interface KeyboardToolBar : UIView <UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIButton *sendButton;

@property (strong, nonatomic) id<KeyboardToolBarDelegate> delegate;

- (IBAction)send:(id)sender;
- (void)resignFirstResponder;
- (void)becomeFirstResponder;

@end