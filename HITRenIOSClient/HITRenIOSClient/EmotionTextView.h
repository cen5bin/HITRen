//
//  EmotionTextView.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-6-3.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmotionTextView : UITextView <UITextViewDelegate> {
    BOOL _realDraw;
    int _lineCount;
}

@property (nonatomic) CGFloat len;
@property (strong, nonatomic) UIFont *font;
@property (strong, nonatomic) UIColor *color;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat width;

+ (NSArray *)getEmotions;
- (void)work;

@end
