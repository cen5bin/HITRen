//
//  UIFunctions.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-3-5.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>

id getViewControllerOfName(NSString *name);
void alert(NSString *title, NSString *message, id delegate);
void drawStringWithFontInRect(NSString *string, UIFont *font, CGRect rect);
id getViewFromNib(NSString *name, id owner);
