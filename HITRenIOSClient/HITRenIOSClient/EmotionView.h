//
//  EmotionView.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-6-2.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmotionView : UIScrollView {
    UITapGestureRecognizer *_tapRecognizer;
}

+ (id)sharedInstance;

@end
