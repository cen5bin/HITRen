//
//  EmotionView.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-6-2.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KeyboardToolBar;
@interface EmotionView : UIScrollView {
    UITapGestureRecognizer *_tapRecognizer;
    NSArray *_emotionText;
}

+ (id)sharedInstance;
@property (nonatomic, strong) KeyboardToolBar *keyboardToolBar;


@end
