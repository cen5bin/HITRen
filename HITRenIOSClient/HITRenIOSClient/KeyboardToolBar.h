//
//  KeyboardToolBar.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-13.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardToolBarDelegate.h"

@interface KeyboardToolBar : UIView <UITextViewDelegate> {
//    BOOL _empty;
    UILabel *_placeHolderLabel;
    UIScrollView *_emotionView;
}

@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIButton *sendButton;
@property (strong, nonatomic) IBOutlet UIButton *emotionButton;

@property (strong, nonatomic) id<KeyboardToolBarDelegate> delegate;
@property (strong, nonatomic) NSString *placeHolder;
@property (nonatomic) BOOL emotionButtonState;

- (IBAction)send:(id)sender;
- (IBAction)emotionButtonClicked:(id)sender;

- (void)resignFirstResponder;
- (void)resignFirstResponderNotHideAtOnce;
- (void)becomeFirstResponder;

@end
