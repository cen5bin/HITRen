//
//  MyActivityIndicatorView.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-6-6.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyActivityIndicatorView : UIView {
    UIView *_backgroundView;
}
@property (strong, nonatomic) IBOutlet UILabel *textLabel;

- (void)showInView:(UIView *)view;
- (void)hide;
@end
