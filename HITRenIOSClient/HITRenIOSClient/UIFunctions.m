//
//  UIFunctions.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-3-5.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "UIFunctions.h"

id getViewControllerOfName(NSString *name) {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
    id controller = [storyboard instantiateViewControllerWithIdentifier:name];
    return controller;
}