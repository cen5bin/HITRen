//
//  ChatCell.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-26.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatCell : UITableViewCell {
    UIImage *_bubble;
    UIImageView *_bubbleImageView;
}

@property (strong, nonatomic) IBOutlet UIImageView *pic;

@property (strong, nonatomic) NSString *text;
- (void)show;

+ (CGFloat)calculateCellHeight:(NSString *)text;
@end
