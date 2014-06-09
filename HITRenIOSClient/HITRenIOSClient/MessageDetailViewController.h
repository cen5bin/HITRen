//
//  MessageDetailViewController.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-23.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentListViewDelegate.h"
#import "KeyboardToolBarDelegate.h"


@class Message, CommentListView,KeyboardToolBar,MyActivityIndicatorView;
@interface MessageDetailViewController : UIViewController <CommentListViewDelegate,UIScrollViewDelegate,KeyboardToolBarDelegate,UITextViewDelegate> {
    KeyboardToolBar *_keyboardToolBar;
    MyActivityIndicatorView *_myActivityIndicatorView;
//    NSMutableSet *_downloadingImageSet;
}


@property (strong, nonatomic) IBOutlet UIImageView *topBar;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIImageView *pic;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIView *cellBar;
@property (strong, nonatomic) IBOutlet UIButton *likedButton;

@property (strong, nonatomic) IBOutlet UITextView *likedListView;
@property (strong, nonatomic) IBOutlet CommentListView *commentListView;

@property (strong, nonatomic) IBOutlet UIView *imageContainer;


@property (strong, nonatomic) Message *message;
@property (nonatomic) BOOL liked;
@property (strong, nonatomic) NSMutableArray *likedList;
@property (strong, nonatomic) NSMutableArray *commentList; //评论列表，每个单元是个dic
@property (strong, nonatomic) NSMutableArray *userList;    //评论列表中每一列中的uid
@property (nonatomic) int targetUid;

@property (strong, nonatomic) NSMutableSet *downloadingImageSet;

- (void)update;
- (void)updateCommentList;
- (IBAction)likeMessage:(id)sender;
- (IBAction)beginToComment:(id)sender;

@end
