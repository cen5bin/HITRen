//
//  TextBoxDelegate.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-6-6.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TextBox;
@protocol TextBoxDelegate <NSObject>

- (void)textBox:(TextBox *)textBox buttonClickedAtIndex:(int)index;

@end
