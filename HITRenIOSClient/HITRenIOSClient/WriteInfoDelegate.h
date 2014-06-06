//
//  WriteInfoDelegate.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-6-7.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WriterInfoView;
@protocol WriteInfoDelegate <NSObject>

- (void)writeInfo:(WriterInfoView *)writerInfo buttonClickedAtIndex:(int)index;
@end
