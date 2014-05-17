//
//  ShortMessageCell.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-4-22.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageCellDelegate.h"

@interface ShortMessageCell : UITableViewCell <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *picture;
@property (strong, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIView *cellBar;

@property (strong, nonatomic) IBOutlet UIButton *likedButton;
@property (strong, nonatomic) IBOutlet UIButton *commentButton;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;

@property (strong, nonatomic) IBOutlet UITextView *likedListView;
@property (strong, nonatomic) IBOutlet UITextView *commentListView;
@property (strong, nonatomic) IBOutlet UITextField *commentField;
@property (strong, nonatomic) IBOutlet UIView *commentBgView;


@property (strong, nonatomic) id<MessageCellDelegate> delegate;
@property (nonatomic) BOOL liked;
@property (strong, nonatomic) NSMutableArray *likedList;
@property (strong, nonatomic) NSMutableArray *commentList;

- (IBAction)likeMessage:(id)sender;
- (IBAction)commentMessage:(id)sender;
- (IBAction)shareMessage:(id)sender;

- (void)update; //点赞信息的更新
- (void)updateCommentList; //评论信息的更新

@end
