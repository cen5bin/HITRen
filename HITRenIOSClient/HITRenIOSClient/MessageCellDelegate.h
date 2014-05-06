//
//  MessageCellDelegate.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-6.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MessageCellDelegate <NSObject>

@optional
- (void)likeMessage:(id)sender;
- (void)dislikeMessage:(id)sender;
- (void)commentMessage:(id)sender;
- (void)shareMessage:(id)sender;
@end
