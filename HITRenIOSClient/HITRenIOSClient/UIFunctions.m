//
//  UIFunctions.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-3-5.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "UIFunctions.h"
#import "AppData.h"

id getViewControllerOfName(NSString *name) {
    AppData *appData = [AppData sharedInstance];
    if ([appData.viewControllerDic objectForKey:name]) return [appData.viewControllerDic objectForKey:name];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
    id controller = [storyboard instantiateViewControllerWithIdentifier:name];
    [appData.viewControllerDic setObject:controller forKey:name];
    return controller;
}

void alert(NSString *title, NSString *message, id delegate) {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
}

void drawStringWithFontInRect(NSString *string, UIFont *font, CGRect rect) {
    CGSize size = [string sizeWithFont:font];
    CGRect rect1 = rect;
    rect1.origin.y += (rect.size.height - size.height) / 2;
    [string drawInRect:rect1 withFont:font lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
}

id getViewFromNib(NSString *name, id owner) {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed: name owner:owner options:nil];
    return [array objectAtIndex:0];
}

