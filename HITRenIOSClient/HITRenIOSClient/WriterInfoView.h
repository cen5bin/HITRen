//
//  WriterInfoView.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-6-7.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WriteInfoDelegate.h"

@class UserInfo;
@interface WriterInfoView : UIView {
    UIView *_backgroundView;
}

@property (strong, nonatomic) IBOutlet UIImageView *pic;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UIButton *concernButton;
@property (strong, nonatomic) IBOutlet UIButton *sendMessageButton;
@property (strong, nonatomic) IBOutlet UIButton *homeButton;

@property (strong, nonatomic) UIViewController *parentViewController;

@property (strong, nonatomic) id <WriteInfoDelegate> delegate;
@property (strong, nonatomic) UserInfo *userInfo;
@property (nonatomic) BOOL concerned;

- (IBAction)buttonClicked:(id)sender;

- (void)showInView:(UIView *)view;
- (void)hide;

- (IBAction)concernButtonTouchDown:(id)sender;
- (IBAction)sendMessageButtonTouchDown:(id)sender;
- (void)updateConcernedButton;

@end
