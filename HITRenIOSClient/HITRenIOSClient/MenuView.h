//
//  MenuView.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-4-21.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuDelegate.h"

@interface MenuView : UIView {
    NSMutableArray *_items;
    int _index;
}

@property (strong, nonatomic) id<MenuDelegate> delegate;
@end
