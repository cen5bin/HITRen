//
//  CommentListView.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-18.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentListViewDelegate.h"

@interface CommentListView : UITextView

@property (strong, nonatomic) id<CommentListViewDelegate> commentListViewDelegate;
    
@end
