//
//  ShortMessageCell.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-4-22.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageCellDelegate.h"
#import "CommentListViewDelegate.h"

@class CommentListView, MyImageView;
@interface ShortMessageCell : UITableViewCell <UITextFieldDelegate,UITextViewDelegate,CommentListViewDelegate> {
    UITapGestureRecognizer *_tapGestureRecognizer;
}
@property (strong, nonatomic) IBOutlet MyImageView *picture;
@property (strong, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIView *cellBar;

@property (strong, nonatomic) IBOutlet UIButton *likedButton;
@property (strong, nonatomic) IBOutlet UIButton *commentButton;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;

@property (strong, nonatomic) IBOutlet UITextView *likedListView;
@property (strong, nonatomic) IBOutlet CommentListView *commentListView;
@property (strong, nonatomic) IBOutlet UITextField *commentField;
@property (strong, nonatomic) IBOutlet UIView *commentBgView;

@property (strong, nonatomic) IBOutlet UIView *imageContainer;

@property (strong, nonatomic) IBOutlet UIView *commentButtonBgView;


@property (strong, nonatomic) id<MessageCellDelegate> delegate;
@property (nonatomic) BOOL liked;
@property (strong, nonatomic) NSMutableArray *likedList;
@property (strong, nonatomic) NSMutableArray *commentList; //评论列表，每个单元是个dic
@property (strong, nonatomic) NSMutableArray *userList;    //评论列表中每一列中的uid
@property (nonatomic) int targetUid;

- (IBAction)likeMessage:(id)sender;
- (IBAction)commentMessage:(id)sender;
- (IBAction)shareMessage:(id)sender;

- (void)update; //点赞信息的更新
- (void)updateCommentList; //评论信息的更新

@end
