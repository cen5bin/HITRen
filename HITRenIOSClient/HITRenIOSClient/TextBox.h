//
//  TextBox.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-6-6.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextBoxDelegate.h"

@interface TextBox : UIView {
    UIView *_backgroundView;
}
@property (strong, nonatomic) IBOutlet UILabel *textLabel;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) id <TextBoxDelegate> delegate;

- (IBAction)confirm:(id)sender;
- (IBAction)cancel:(id)sender;

- (void)showInView:(UIView *)view;
- (void)hide;
@end
