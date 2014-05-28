//
//  ContactGroupCell.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-28.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactGroupCell : UITableViewCell {
    BOOL _showList;
}
@property (strong, nonatomic) IBOutlet UIImageView *pic;
@property (strong, nonatomic) IBOutlet UILabel *gnameLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;

- (void)setShowList:(BOOL)value;

@end
